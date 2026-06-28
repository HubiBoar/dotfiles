local M = {}

M.config = {
    model = "qwen3-coder:30b",
    ollama_url = "http://localhost:11434/api/generate",

    input_height = 5,

    keep_alive = "3h",

    options = {
        num_ctx = 32768,
        num_predict = 2048,
        temperature = 0.2,
        top_p = 0.9,
    },

    system_prompt = table.concat({
        "You are Clanker Duck, a concise coding assistant.",
        "Keep explanations short and practical.",
        "Prefer simple solutions.",
        "Do not be verbose.",
        "Answer with code snippets whenever its needed.",
        "When editing code, show only the changed part unless full file is needed.",
    }, "\n"),
}

local ns = vim.api.nvim_create_namespace("clanker-duck")

local function setup_highlights()
  vim.api.nvim_set_hl(0, "ClankerUserHeader", {
    fg = "#7aa2f7",
    bold = true,
  })

  vim.api.nvim_set_hl(0, "ClankerAssistantHeader", {
    fg = "#9ece6a",
    bold = true,
  })

  vim.api.nvim_set_hl(0, "ClankerSeparator", {
    fg = "#565f89",
  })
end

local function set_lines(buf, lines)
    vim.api.nvim_buf_set_option(buf, "modifiable", true)
    vim.api.nvim_buf_set_lines(buf, -1, -1, false, lines)
    vim.api.nvim_buf_set_option(buf, "modifiable", false)
end

local function append_text(buf, text)
  local start_line = vim.api.nvim_buf_line_count(buf)
  local lines = vim.split(tostring(text), "\n", { plain = true })

  vim.api.nvim_buf_set_option(buf, "modifiable", true)
  vim.api.nvim_buf_set_lines(buf, -1, -1, false, lines)
  vim.api.nvim_buf_set_option(buf, "modifiable", false)

  for i, line in ipairs(lines) do
    local line_nr = start_line + i - 1

    if line:match("^── You ") then
      vim.api.nvim_buf_add_highlight(buf, ns, "ClankerUserHeader", line_nr, 0, -1)
    elseif line:match("^── Clanker Duck ") then
      vim.api.nvim_buf_add_highlight(buf, ns, "ClankerAssistantHeader", line_nr, 0, -1)
    elseif line:match("^─+$") then
      vim.api.nvim_buf_add_highlight(buf, ns, "ClankerSeparator", line_nr, 0, -1)
    end
  end

  for _, win in ipairs(vim.fn.win_findbuf(buf)) do
    vim.api.nvim_win_set_cursor(win, { vim.api.nvim_buf_line_count(buf), 0 })
  end
end

local function read_input(buf)
    local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
    return vim.trim(table.concat(lines, "\n"))
end

local function clear_input(buf)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, { "" })
end

local function ask_ollama(state, prompt)
    append_text(
      state.chat_buf,
      "\n────────────────────────────────────────\n"
        .. "── You ─────────────────────────────────\n"
        .. prompt
        .. "\n\n"
        .. "── Clanker Duck ────────────────────────\n"
        .. "..."
    )

    local payload = vim.json.encode({
      model = M.config.model,
      prompt = M.config.system_prompt .. "\n\nUser:\n" .. prompt,
      stream = false,
      keep_alive = M.config.keep_alive,
      options = M.config.options,
    })


    local stdout = {}
    local stderr = {}

    vim.fn.jobstart({
        "curl",
        "-sS",
        M.config.ollama_url,
        "-H",
        "Content-Type: application/json",
        "-d",
        payload,
    }, {
        stdout_buffered = true,
        stderr_buffered = true,

        on_stdout = function(_, data)
            if data then
                stdout = data
            end
        end,

        on_stderr = function(_, data)
            if data then
                stderr = data
            end
        end,

        on_exit = function(_, code)
            vim.schedule(function()
                local lines = vim.api.nvim_buf_get_lines(state.chat_buf, 0, -1, false)

                -- Remove temporary "..."
                if lines[#lines] == "..." then
                    table.remove(lines, #lines)
                end

                vim.api.nvim_buf_set_option(state.chat_buf, "modifiable", true)
                vim.api.nvim_buf_set_lines(state.chat_buf, 0, -1, false, lines)
                vim.api.nvim_buf_set_option(state.chat_buf, "modifiable", false)

                if code ~= 0 then
                    append_text(state.chat_buf, "Error talking to Ollama:\n" .. table.concat(stderr, "\n"))
                    return
                end

                local raw = table.concat(stdout, "\n")
                local ok, decoded = pcall(vim.json.decode, raw)

                if not ok or not decoded.response then
                    append_text(state.chat_buf, "Invalid Ollama response:\n" .. raw)
                    return
                end

                append_text(state.chat_buf, vim.trim(decoded.response))
            end)
        end,
    })
end

local function send(state)
    local prompt = read_input(state.input_buf)

    if prompt == "" then
        return
    end

    clear_input(state.input_buf)
    ask_ollama(state, prompt)
end

function M.open()
    setup_highlights()

    local chat_buf = vim.api.nvim_create_buf(false, true)
    local input_buf = vim.api.nvim_create_buf(false, true)

    -- Create chat window in current tab.
    vim.cmd("enew")
    local chat_win = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_buf(chat_win, chat_buf)

    vim.bo[chat_buf].buftype = "nofile"
    vim.bo[chat_buf].bufhidden = "wipe"
    vim.bo[chat_buf].swapfile = false
    vim.bo[chat_buf].filetype = "markdown"
    vim.bo[chat_buf].modifiable = false

    set_lines(chat_buf, {
        "# Clanker Duck",
        "",
        "Ask a coding question below.",
    })

    -- Input window at the bottom.
    vim.cmd("botright " .. M.config.input_height .. "split")
    local input_win = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_buf(input_win, input_buf)

    vim.bo[input_buf].buftype = "nofile"
    vim.bo[input_buf].bufhidden = "wipe"
    vim.bo[input_buf].swapfile = false
    vim.bo[input_buf].filetype = "markdown"

    vim.api.nvim_buf_set_lines(input_buf, 0, -1, false, { "" })

    local state = {
      chat_buf = chat_buf,
      input_buf = input_buf,
      chat_win = chat_win,
      input_win = input_win,
    }

    -- Input window: Enter sends prompt.
    vim.keymap.set("n", "<CR>", function()
      send(state)
    end, {
      buffer = input_buf,
      nowait = true,
      desc = "Send Clanker prompt",
    })

    vim.keymap.set("i", "<C-CR>", function()
      send(state)
    end, {
      buffer = input_buf,
      nowait = true,
      desc = "Send Clanker prompt",
    })
    -- Input window: Esc goes to chat window.
    vim.keymap.set("n", "<Esc>", function()
      if vim.api.nvim_win_is_valid(state.chat_win) then
        vim.api.nvim_set_current_win(state.chat_win)
      end
    end, {
      buffer = input_buf,
      nowait = true,
      desc = "Focus Clanker chat",
    })

    -- Chat window: Esc goes back to input window.
    vim.keymap.set("n", "<Esc>", function()
      if vim.api.nvim_win_is_valid(state.input_win) then
        vim.api.nvim_set_current_win(state.input_win)
      end
    end, {
      buffer = chat_buf,
      nowait = true,
      desc = "Focus Clanker input",
    })

    vim.keymap.set("n", "i", function()
      if vim.api.nvim_win_is_valid(state.input_win) then
        vim.api.nvim_set_current_win(state.input_win)
      end
    end, {
      buffer = chat_buf,
      nowait = true,
      desc = "Focus Clanker input",
    })

    vim.api.nvim_set_current_win(input_win)
    vim.cmd("startinsert")
end

function M.setup()
    M.configure({
      model = "qwen3-coder:30b",
      ollama_url = "http://localhost:11434/api/generate",

      keep_alive = "10m",

      options = {
        num_ctx = 32768,
        num_predict = 2048,
        temperature = 0.2,
        top_p = 0.9,
      },
    })

end

function M.configure(opts)
    M.config = vim.tbl_deep_extend("force", M.config, opts or {})

    vim.api.nvim_create_user_command("Clanker", function()
        M.open()
    end, {
        desc = "Open Clanker Duck chat",
        force = true,
    })
end

return M
