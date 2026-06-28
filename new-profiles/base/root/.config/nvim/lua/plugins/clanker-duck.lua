local M = {}

M.config = {
    model = "qwen3-coder:30b",
    ollama_url = "http://localhost:11434/api/generate",

    input_height = 20,

    keep_alive = "3h",

    options = {
        num_ctx = 32768,
        num_predict = 2048,
        temperature = 0.2,
        top_p = 0.9,
    },

    system_prompt = table.concat({
        "You are Clanker Duck, a concise coding assistant.",
        "Provide direct, practical answers only.",
        "Focus on essential details and concrete solutions.",
        "Keep responses brief but complete.",
        "Explain potential issues clearly.",
        "Show code when crucial for understanding.",
        "Avoid verbosity and chit-chat.",
        "Be straight to the point - no fluff.",
    }, "\n")
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

local function split_wrapped(text, width)
  local result = {}

  for _, line in ipairs(vim.split(tostring(text), "\n", { plain = true })) do
    if line == "" then
      table.insert(result, "")
    else
      while #line > width do
        table.insert(result, line:sub(1, width))
        line = line:sub(width + 1)
      end

      table.insert(result, line)
    end
  end

  return result
end

local function append_lines(buf, lines, highlights)
  local start_line = vim.api.nvim_buf_line_count(buf)

  vim.api.nvim_buf_set_option(buf, "modifiable", true)
  vim.api.nvim_buf_set_lines(buf, -1, -1, false, lines)
  vim.api.nvim_buf_set_option(buf, "modifiable", false)

  if highlights then
    for i, hl in pairs(highlights) do
      vim.api.nvim_buf_add_highlight(buf, ns, hl, start_line + i - 1, 0, -1)
    end
  end

  for _, win in ipairs(vim.fn.win_findbuf(buf)) do
    vim.api.nvim_win_set_cursor(win, { vim.api.nvim_buf_line_count(buf), 0 })
  end
end

local function append_user(buf, text)
  local width = 120
  local content_width = width - 4
  local text_lines = split_wrapped(text, content_width)

  local lines = { "" }
  local highlights = {}

  table.insert(lines, "╭" .. string.rep("─", width - 2) .. "╮")
  highlights[#lines] = "ClankerUserBorder"

  for _, line in ipairs(text_lines) do
    local padded = line .. string.rep(" ", content_width - #line)
    table.insert(lines, "│ " .. padded .. " │")
    highlights[#lines] = "ClankerUserBubble"
  end

  table.insert(lines, "╰" .. string.rep("─", width - 2) .. "╯")
  highlights[#lines] = "ClankerUserBorder"

  append_lines(buf, lines, highlights)
end

local function append_assistant(buf, text)
  local lines = split_wrapped(text, 100)
  table.insert(lines, 1, "")

  local highlights = {}
  for i = 1, #lines do
    highlights[i] = "ClankerAssistant"
  end

  append_lines(buf, lines, highlights)
end

local function append_dim(buf, text)
  local lines = vim.split(tostring(text), "\n", { plain = true })

  local highlights = {}
  for i = 1, #lines do
    highlights[i] = "ClankerDim"
  end

  append_lines(buf, lines, highlights)
end
local function set_lines(buf, lines)
    vim.api.nvim_buf_set_option(buf, "modifiable", true)
    vim.api.nvim_buf_set_lines(buf, -1, -1, false, lines)
    vim.api.nvim_buf_set_option(buf, "modifiable", false)
end

local function read_input(buf)
    local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
    return vim.trim(table.concat(lines, "\n"))
end

local function clear_input(buf)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, { "" })
end

local function build_prompt(messages)
  local parts = {
    M.config.system_prompt,
    "",
    "Conversation:",
  }

  for _, message in ipairs(messages) do
    if message.role == "user" then
      table.insert(parts, "")
      table.insert(parts, "User:")
      table.insert(parts, message.content)
    elseif message.role == "assistant" then
      table.insert(parts, "")
      table.insert(parts, "Assistant:")
      table.insert(parts, message.content)
    end
  end

  table.insert(parts, "")
  table.insert(parts, "Assistant:")

  return table.concat(parts, "\n")
end
local function ask_ollama(state, prompt)
    table.insert(state.history, {role = "user", content = prompt})

    append_user(state.chat_buf, prompt)
    append_assistant(state.chat_buf, "...")

    local full_prompt = build_prompt(state.history)

    local payload = vim.json.encode({
        model = M.config.model,
        prompt = full_prompt,
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
                    append_dim(state.chat_buf, "Error talking to Ollama:\n" .. table.concat(stderr, "\n"))
                    return
                end

                local raw = table.concat(stdout, "\n")
                local ok, decoded = pcall(vim.json.decode, raw)

                if not ok or not decoded.response then
                    append_dim(state.chat_buf, "Invalid Ollama response:\n" .. raw)
                    return
                end

                local answer = vim.trim(decoded.response)

                table.insert(state.history, {
                  role = "assistant",
                  content = answer,
                })

                append_assistant(state.chat_buf, answer)
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

    vim.api.nvim_buf_set_name(chat_buf, "Clanker Duck Chat")
    vim.api.nvim_buf_set_name(input_buf, "Clanker Duck Input")

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
      history = {},
    }

    -- Input window: Enter sends prompt.
    vim.keymap.set("n", "<CR>", function()
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
