local M = {}

M.config = {
    model = "qwen3-coder:30b",
    ollama_url = "http://localhost:11434/api/generate",

    max_file_bytes = 80 * 1024,
    max_total_bytes = 400 * 1024,
    max_files = 120,

    keymap_toggle = "<C-a>",
    keymap_mode_toggle = "<Tab>",

    allowed_extensions = {
        lua = true,
        js = true,
        jsx = true,
        ts = true,
        tsx = true,
        py = true,
        rs = true,
        go = true,
        java = true,
        cs = true,
        c = true,
        h = true,
        cpp = true,
        hpp = true,
        md = true,
        json = true,
        yaml = true,
        yml = true,
        toml = true,
        html = true,
        css = true,
        scss = true,
        sh = true,
        vim = true,
        csproj = true,
        sln = true,
    },

    ignored_dirs = {
        [".git"] = true,
        ["node_modules"] = true,
        ["dist"] = true,
        ["build"] = true,
        [".next"] = true,
        ["target"] = true,
        [".venv"] = true,
        [".env"] = true,
        ["vendor"] = true,
        [".cache"] = true,
        ["bin"] = true,
        ["obj"] = true,
    },
}

M.sessions = {}

M.state = {
    root = nil,

    context_mode = nil, -- "directory" or "file"
    context_file = nil,

    mode = "plan", -- "plan" or "build"

    chat_win = nil,
    chat_buf = nil,

    input_win = nil,
    input_buf = nil,

    previous_win = nil,
    augroup = nil,
}

local ns = vim.api.nvim_create_namespace("simple_agent_ui")

local function notify(msg, level)
    vim.notify(msg, level or vim.log.levels.INFO)
end

local function normalize(path)
    return vim.fs.normalize(vim.fn.fnamemodify(path, ":p"))
end

local function setup_highlights()
    vim.api.nvim_set_hl(0, "SimpleAgentModePlan", {
        fg = "#7aa2f7",
        bold = true,
    })

    vim.api.nvim_set_hl(0, "SimpleAgentModeBuild", {
        fg = "#f7768e",
        bold = true,
    })

    vim.api.nvim_set_hl(0, "SimpleAgentContext", {
        fg = "#9ece6a",
        bold = true,
    })

    vim.api.nvim_set_hl(0, "SimpleAgentPath", {
        fg = "#e0af68",
        bold = true,
    })

    vim.api.nvim_set_hl(0, "SimpleAgentModel", {
        fg = "#7dcfff",
        bold = true,
    })

    vim.api.nvim_set_hl(0, "SimpleAgentKeys", {
        fg = "#bb9af7",
        bold = true,
    })

    vim.api.nvim_set_hl(0, "SimpleAgentUser", {
        fg = "#7dcfff",
        bold = true,
    })

    vim.api.nvim_set_hl(0, "SimpleAgentAssistant", {
        fg = "#c0caf5",
        bold = true,
    })

    vim.api.nvim_set_hl(0, "SimpleAgentSystem", {
        fg = "#e0af68",
        bold = true,
    })
end

local function current_context()
    local bufnr = vim.api.nvim_get_current_buf()
    local filetype = vim.bo[bufnr].filetype

    if filetype == "oil" then
        local ok, oil = pcall(require, "oil")

        if ok then
            local dir = oil.get_current_dir(bufnr)

            if dir and dir ~= "" then
                return {
                    mode = "directory",
                    root = normalize(dir),
                    file = nil,
                }
            end
        end
    end

    local current = vim.api.nvim_buf_get_name(bufnr)

    if current ~= "" and vim.fn.filereadable(current) == 1 then
        local file = normalize(current)

        return {
            mode = "file",
            root = normalize(vim.fn.fnamemodify(file, ":h")),
            file = file,
        }
    end

    return {
        mode = "directory",
        root = normalize(vim.fn.getcwd()),
        file = nil,
    }
end

local function session_key()
    if M.state.context_mode == "file" then
        return "file:" .. M.state.context_file
    end

    return "dir:" .. M.state.root
end

local function session()
    local key = session_key()

    M.sessions[key] = M.sessions[key] or {
        messages = {},
        busy = false,
        last_write_summary = nil,
        last_write_error = nil,
    }

    return M.sessions[key]
end

local function is_inside(path, root)
    local base = normalize(root)
    local full = normalize(path)

    return full == base or full:sub(1, #base + 1) == base .. "/"
end

local function is_inside_context_root(path)
    return is_inside(path, M.state.root)
end

local function relative_to(path, base)
    local root = normalize(base)
    local full = normalize(path)

    if full == root then
        return "."
    end

    if full:sub(1, #root + 1) == root .. "/" then
        return full:sub(#root + 2)
    end

    return full
end

local function context_relative(path)
    return relative_to(path, M.state.root)
end

local function apply_relative(path)
    return relative_to(path, M.state.root)
end

local function extension(path)
    return path:match("%.([^%.]+)$")
end

local function should_include_file(path)
    local ext = extension(path)

    if not ext then
        return false
    end

    return M.config.allowed_extensions[ext] == true
end

local function should_ignore_dir(name)
    return M.config.ignored_dirs[name] == true
end

local function scan_files(root)
    local files = {}

    local function scan(dir)
        if #files >= M.config.max_files then
            return
        end

        local ok, entries = pcall(vim.fn.readdir, dir)

        if not ok then
            return
        end

        table.sort(entries)

        for _, entry in ipairs(entries) do
            if #files >= M.config.max_files then
                return
            end

            if not should_ignore_dir(entry) then
                local full = normalize(dir .. "/" .. entry)

                if is_inside_context_root(full) then
                    local stat = vim.loop.fs_stat(full)

                    if stat and stat.type == "directory" then
                        scan(full)
                    elseif stat and stat.type == "file" and should_include_file(full) then
                        table.insert(files, full)
                    end
                end
            end
        end
    end

    scan(root)

    return files
end

local function read_file(path)
    path = normalize(path)

    if not is_inside_context_root(path) then
        return nil
    end

    local stat = vim.loop.fs_stat(path)

    if not stat or stat.type ~= "file" then
        return nil
    end

    if stat.size > M.config.max_file_bytes then
        return nil
    end

    local ok, lines = pcall(vim.fn.readfile, path)

    if not ok then
        return nil
    end

    return table.concat(lines, "\n")
end

local function render_single_file_context(file)
    local content = read_file(file)

    if not content then
        return ""
    end

    return table.concat({
        "FILE: " .. apply_relative(file),
        "CONTEXT_RELATIVE_FILE: " .. context_relative(file),
        "```",
        content,
        "```",
    }, "\n")
end

local function render_directory_context()
    local files = scan_files(M.state.root)
    local chunks = {}
    local total = 0

    for _, file in ipairs(files) do
        local content = read_file(file)

        if content then
            total = total + #content

            if total > M.config.max_total_bytes then
                table.insert(chunks, table.concat({
                    "NOTE:",
                    "Project context was truncated because max_total_bytes was reached.",
                    "Some files under the context root may not be visible in this request.",
                }, "\n"))
                break
            end

            table.insert(chunks, table.concat({
                "FILE: " .. apply_relative(file),
                "CONTEXT_RELATIVE_FILE: " .. context_relative(file),
                "```",
                content,
                "```",
            }, "\n"))
        end
    end

    return table.concat(chunks, "\n\n")
end

local function render_project_context()
    if M.state.context_mode == "file" then
        return render_single_file_context(M.state.context_file)
    end

    return render_directory_context()
end

local function render_history_for_prompt()
    local s = session()
    local out = {}

    for _, msg in ipairs(s.messages) do
        if not msg.pending then
            table.insert(out, msg.role .. ":")
            table.insert(out, msg.content)
            table.insert(out, "")
        end
    end

    return table.concat(out, "\n")
end

local function context_label()
    if M.state.context_mode == "file" and M.state.context_file then
        return "FILE  " .. apply_relative(M.state.context_file)
    end

    return "DIR   " .. M.state.root
end

local function mode_title()
    if M.state.mode == "build" then
        return " BUILD "
    end

    return " PLAN "
end

local function mode_highlight()
    if M.state.mode == "build" then
        return "SimpleAgentModeBuild"
    end

    return "SimpleAgentModePlan"
end

local function mode_line()
    if M.state.mode == "build" then
        return "BUILD mode - file blocks are written to disk"
    end

    return "PLAN mode - discussion only"
end

local function controls_label()
    local s = session()

    if s.busy then
        return "KEYS  waiting for Ollama..."
    end

    return "KEYS  Enter send   Tab toggle PLAN/BUILD   Ctrl-a close   i focus input"
end

local function render_chat_lines()
    local s = session()
    local lines = {}

    if #s.messages == 0 then
        table.insert(lines, "No messages yet.")
        table.insert(lines, "")
    else
        for _, msg in ipairs(s.messages) do
            table.insert(lines, msg.role .. ":")

            for _, line in ipairs(vim.split(msg.content, "\n")) do
                table.insert(lines, line)
            end

            table.insert(lines, "")
        end
    end

    table.insert(lines, string.rep("─", 72))
    table.insert(lines, mode_line())
    table.insert(lines, "MODEL    " .. M.config.model)
    table.insert(lines, "CONTEXT  " .. context_label())
    table.insert(lines, controls_label())

    return lines
end

local function update_input_title()
    if not M.state.input_win or not vim.api.nvim_win_is_valid(M.state.input_win) then
        return
    end

    pcall(vim.api.nvim_win_set_config, M.state.input_win, {
        title = mode_title(),
        title_pos = "center",
    })
end

local function apply_chat_highlights()
    if not M.state.chat_buf or not vim.api.nvim_buf_is_valid(M.state.chat_buf) then
        return
    end

    vim.api.nvim_buf_clear_namespace(M.state.chat_buf, ns, 0, -1)

    local lines = vim.api.nvim_buf_get_lines(M.state.chat_buf, 0, -1, false)

    for i, line in ipairs(lines) do
        local row = i - 1

        if line == "User:" then
            vim.api.nvim_buf_add_highlight(M.state.chat_buf, ns, "SimpleAgentUser", row, 0, -1)
        elseif line == "Assistant:" then
            vim.api.nvim_buf_add_highlight(M.state.chat_buf, ns, "SimpleAgentAssistant", row, 0, -1)
        elseif line == "System:" then
            vim.api.nvim_buf_add_highlight(M.state.chat_buf, ns, "SimpleAgentSystem", row, 0, -1)
        elseif line:match("^PLAN mode") or line:match("^BUILD mode") then
            vim.api.nvim_buf_add_highlight(M.state.chat_buf, ns, mode_highlight(), row, 0, -1)
        elseif line:match("^MODEL%s+") then
            vim.api.nvim_buf_add_highlight(M.state.chat_buf, ns, "SimpleAgentModel", row, 0, 7)
            vim.api.nvim_buf_add_highlight(M.state.chat_buf, ns, "SimpleAgentPath", row, 8, -1)
        elseif line:match("^CONTEXT%s+") then
            vim.api.nvim_buf_add_highlight(M.state.chat_buf, ns, "SimpleAgentContext", row, 0, 7)

            local path_start = line:find("  ", 1, true)

            if path_start then
                vim.api.nvim_buf_add_highlight(M.state.chat_buf, ns, "SimpleAgentPath", row, path_start + 1, -1)
            end
        elseif line:match("^KEYS%s+") then
            vim.api.nvim_buf_add_highlight(M.state.chat_buf, ns, "SimpleAgentKeys", row, 0, -1)
        elseif line:match("^```file%s+") then
            vim.api.nvim_buf_add_highlight(M.state.chat_buf, ns, "SimpleAgentPath", row, 0, -1)
        elseif line:match("^FILE:%s+") or line:match("^CONTEXT_RELATIVE_FILE:%s+") then
            vim.api.nvim_buf_add_highlight(M.state.chat_buf, ns, "SimpleAgentPath", row, 0, -1)
        end
    end
end

local function clamp_chat_scroll()
    if not M.state.chat_win or not vim.api.nvim_win_is_valid(M.state.chat_win) then
        return
    end

    vim.api.nvim_win_call(M.state.chat_win, function()
        local line_count = vim.api.nvim_buf_line_count(M.state.chat_buf)
        local height = vim.api.nvim_win_get_height(M.state.chat_win)
        local max_topline = math.max(1, line_count - height + 1)
        local view = vim.fn.winsaveview()

        if view.topline > max_topline then
            view.topline = max_topline
            vim.fn.winrestview(view)
        end
    end)
end

local function scroll_chat_to_bottom()
    if not M.state.chat_win or not vim.api.nvim_win_is_valid(M.state.chat_win) then
        return
    end

    local line_count = vim.api.nvim_buf_line_count(M.state.chat_buf)

    pcall(vim.api.nvim_win_set_cursor, M.state.chat_win, {
        math.max(1, line_count),
        0,
    })

    vim.api.nvim_win_call(M.state.chat_win, function()
        vim.cmd("normal! z-")
    end)

    clamp_chat_scroll()
end

local function set_chat_lines(lines)
    if not M.state.chat_buf or not vim.api.nvim_buf_is_valid(M.state.chat_buf) then
        return
    end

    local current_win = vim.api.nvim_get_current_win()
    local cursor = nil

    if M.state.chat_win and vim.api.nvim_win_is_valid(M.state.chat_win) then
        cursor = vim.api.nvim_win_get_cursor(M.state.chat_win)
    end

    vim.bo[M.state.chat_buf].readonly = false
    vim.bo[M.state.chat_buf].modifiable = true
    vim.api.nvim_buf_set_lines(M.state.chat_buf, 0, -1, false, lines)
    vim.bo[M.state.chat_buf].modifiable = false
    vim.bo[M.state.chat_buf].readonly = true

    apply_chat_highlights()

    if cursor and M.state.chat_win and vim.api.nvim_win_is_valid(M.state.chat_win) then
        local line_count = vim.api.nvim_buf_line_count(M.state.chat_buf)
        local row = math.min(cursor[1], math.max(1, line_count))
        local col = cursor[2]

        pcall(vim.api.nvim_win_set_cursor, M.state.chat_win, {
            row,
            col,
        })
    end

    clamp_chat_scroll()

    if current_win and vim.api.nvim_win_is_valid(current_win) then
        pcall(vim.api.nvim_set_current_win, current_win)
    end
end

local function set_input_prompt()
    if not M.state.input_buf or not vim.api.nvim_buf_is_valid(M.state.input_buf) then
        return
    end

    if vim.api.nvim_buf_line_count(M.state.input_buf) == 0 then
        vim.api.nvim_buf_set_lines(M.state.input_buf, 0, -1, false, { "" })
    end
end

local function redraw()
    set_chat_lines(render_chat_lines())
    set_input_prompt()
    update_input_title()
end

local function clear_input()
    if not M.state.input_buf or not vim.api.nvim_buf_is_valid(M.state.input_buf) then
        return
    end

    vim.bo[M.state.input_buf].modifiable = true
    vim.api.nvim_buf_set_lines(M.state.input_buf, 0, -1, false, { "" })
    vim.bo[M.state.input_buf].modifiable = true
end

local function get_input_text()
    if not M.state.input_buf or not vim.api.nvim_buf_is_valid(M.state.input_buf) then
        return ""
    end

    local lines = vim.api.nvim_buf_get_lines(M.state.input_buf, 0, -1, false)
    return vim.trim(table.concat(lines, "\n"))
end

local function focus_input()
    scroll_chat_to_bottom()

    if M.state.input_win and vim.api.nvim_win_is_valid(M.state.input_win) then
        vim.api.nvim_set_current_win(M.state.input_win)
    end
end

local function enter_input_mode()
    focus_input()
    vim.cmd("startinsert")
end

local function ollama_generate(prompt, cb)
    local body = vim.json.encode({
        model = M.config.model,
        prompt = prompt,
        stream = false,
        options = {
            temperature = 0.2,
        },
    })

    vim.system({
        "curl",
        "-fsS",
        M.config.ollama_url,
        "-H",
        "Content-Type: application/json",
        "-d",
        body,
    }, { text = true }, function(obj)
        vim.schedule(function()
            if obj.code ~= 0 then
                cb(nil, obj.stderr)
                return
            end

            local ok, decoded = pcall(vim.json.decode, obj.stdout)

            if not ok then
                cb(nil, "Could not decode Ollama response")
                return
            end

            cb(decoded.response or "", nil)
        end)
    end)
end

local function plan_prompt(user_text)
    return table.concat({
        "You are a careful coding assistant inside Neovim.",
        "",
        "You are currently in PLAN mode.",
        "",
        "In PLAN mode:",
        "- Discuss the user's request.",
        "- Explain possible changes.",
        "- Suggest a plan.",
        "- Mention files that would likely change.",
        "- Do not output diffs.",
        "- Do not claim that files were changed.",
        "- Nothing you write will be applied to disk.",
        "",
        "You cannot use tools.",
        "You cannot run commands.",
        "You cannot edit files directly.",
        "",
        "Context root:",
        M.state.root,
        "",
        "Context mode:",
        M.state.context_mode,
        "",
        "CHAT HISTORY:",
        render_history_for_prompt(),
        "",
        "USER MESSAGE:",
        user_text,
        "",
        "PROJECT CONTEXT:",
        render_project_context(),
    }, "\n")
end

local function build_prompt(user_text)
    local current_visible_file = ""

    if M.state.context_mode == "file" and M.state.context_file then
        current_visible_file = apply_relative(M.state.context_file)
    end

    return table.concat({
        "You are a careful coding assistant inside Neovim.",
        "",
        "You are currently in BUILD mode.",
        "",
        "In BUILD mode:",
        "- Continue discussing normally when the user asks questions.",
        "- If the user asks for a concrete code change, output complete replacement file blocks.",
        "- The plugin will write those replacement file blocks directly to the real project files.",
        "- Do not output diffs.",
        "- Do not output patches.",
        "- Do not use ellipses or placeholders in replacement files.",
        "- Do not claim files were changed yourself; the plugin will report writes after your response.",
        "",
        "Replacement file format:",
        "- Use one fenced block per changed file.",
        "- The fence must start with exactly: ```file path/from/apply/root",
        "- The path must be relative to Apply root.",
        "- For existing files, use the exact path shown after FILE: in PROJECT CONTEXT.",
        "- For new files, use a path inside the context root with an allowed extension.",
        "- The block content must be the FULL FINAL FILE CONTENT.",
        "- Include unchanged parts of changed files.",
        "- Do not write any text after the final replacement file block.",
        "",
        "Example:",
        "I will rename the local variable while keeping behavior unchanged.",
        "",
        "```file src/Controller/Program.cs",
        "using Example;",
        "",
        "var bld = new AppBuilder(args);",
        "bld.Run();",
        "```",
        "",
        "File-context rule:",
        "- If Context mode is file, only output a replacement block for the visible file.",
        "- In file context, do not create new files.",
        "- Visible file path:",
        current_visible_file,
        "",
        "Safety rules:",
        "- Only write files inside the context root.",
        "- Only write files relevant to the user's request.",
        "- If the user is still planning or asking questions, do not output file blocks.",
        "",
        "You cannot use tools.",
        "You cannot run commands.",
        "You cannot edit files directly, except by proposing replacement file blocks for the plugin to write.",
        "",
        "Context root:",
        M.state.root,
        "",
        "Context mode:",
        M.state.context_mode,
        "",
        "CHAT HISTORY:",
        render_history_for_prompt(),
        "",
        "USER MESSAGE:",
        user_text,
        "",
        "PROJECT CONTEXT:",
        render_project_context(),
    }, "\n")
end

local function main_prompt(user_text)
    if M.state.mode == "build" then
        return build_prompt(user_text)
    end

    return plan_prompt(user_text)
end

local function replace_pending_message(s, content)
    for i = #s.messages, 1, -1 do
        if s.messages[i].pending then
            s.messages[i] = {
                role = "Assistant",
                content = content,
            }
            return
        end
    end

    table.insert(s.messages, {
        role = "Assistant",
        content = content,
    })
end

local function clean_replacement_path(path)
    if not path or path == "" then
        return nil
    end

    path = vim.trim(path)
    path = path:gsub("^a/", "")
    path = path:gsub("^b/", "")

    if path == "/dev/null" then
        return nil
    end

    if path:match("^/") then
        return nil
    end

    if path:match("%.%.") then
        return nil
    end

    return path
end

local function extract_replacement_files(text)
    if not text or text == "" then
        return {}
    end

    local lines = vim.split(text, "\n")
    local files = {}
    local in_file = false
    local current_path = nil
    local current_lines = {}

    local function finish_current()
        if in_file and current_path then
            table.insert(files, {
                path = current_path,
                content = table.concat(current_lines, "\n"),
            })
        end

        in_file = false
        current_path = nil
        current_lines = {}
    end

    for _, line in ipairs(lines) do
        if not in_file then
            local path = line:match("^```file%s+(.+)%s*$")

            if path then
                local cleaned = clean_replacement_path(path)

                if cleaned then
                    in_file = true
                    current_path = cleaned
                    current_lines = {}
                end
            end
        else
            if line:match("^```%s*$") then
                finish_current()
            else
                table.insert(current_lines, line)
            end
        end
    end

    if in_file then
        finish_current()
    end

    return files
end

local function mkdir_parent(path)
    vim.fn.mkdir(vim.fn.fnamemodify(path, ":h"), "p")
end

local function write_text_file(path, text)
    mkdir_parent(path)

    local lines = vim.split(text, "\n", { plain = true })

    if #lines > 0 and lines[#lines] == "" then
        table.remove(lines, #lines)
    end

    local ok, err = pcall(vim.fn.writefile, lines, path)

    if not ok then
        return false, tostring(err)
    end

    return true, nil
end

local function validate_replacement_file(file)
    local path = clean_replacement_path(file.path)

    if not path then
        return false, "Invalid replacement path: " .. tostring(file.path)
    end

    local absolute = normalize(M.state.root .. "/" .. path)
    local exists = vim.fn.filereadable(absolute) == 1

    if not is_inside_context_root(absolute) then
        return false, "Refusing to write outside context root: " .. path
    end

    if M.state.context_mode == "file" and normalize(absolute) ~= normalize(M.state.context_file) then
        return false, "File context can only write the current file: " .. path
    end

    if not exists and M.state.context_mode ~= "directory" then
        return false, "New files can only be created in directory context: " .. path
    end

    if not exists and not should_include_file(absolute) then
        return false, "New file extension is not allowed: " .. path
    end

    if exists and not should_include_file(absolute) then
        return false, "Existing file extension is not allowed: " .. path
    end

    file.path = path
    file.absolute = absolute
    file.exists = exists

    return true, nil
end

local function apply_replacement_files(response)
    local s = session()

    s.last_write_summary = nil
    s.last_write_error = nil

    if M.state.mode ~= "build" then
        return {
            wrote = false,
            summary = nil,
            error = nil,
        }
    end

    local files = extract_replacement_files(response)

    if #files == 0 then
        return {
            wrote = false,
            summary = nil,
            error = nil,
        }
    end

    local seen = {}

    for _, file in ipairs(files) do
        local ok, err = validate_replacement_file(file)

        if not ok then
            s.last_write_error = err

            return {
                wrote = false,
                summary = nil,
                error = err,
            }
        end

        if seen[file.path] then
            local duplicate_error = "Duplicate replacement block for: " .. file.path
            s.last_write_error = duplicate_error

            return {
                wrote = false,
                summary = nil,
                error = duplicate_error,
            }
        end

        seen[file.path] = true
    end

    local written = {}

    for _, file in ipairs(files) do
        local ok, err = write_text_file(file.absolute, file.content)

        if not ok then
            local write_error = "Could not write " .. file.path .. ": " .. tostring(err)
            s.last_write_error = write_error

            return {
                wrote = #written > 0,
                summary = table.concat(written, ", "),
                error = write_error,
            }
        end

        table.insert(written, file.path)

        local bufnr = vim.fn.bufnr(file.absolute)

        if bufnr ~= -1 and vim.api.nvim_buf_is_valid(bufnr) then
            vim.schedule(function()
                if vim.api.nvim_buf_is_valid(bufnr) then
                    vim.api.nvim_buf_call(bufnr, function()
                        vim.cmd("checktime")
                    end)
                end
            end)
        end
    end

    local summary = table.concat(written, ", ")
    s.last_write_summary = summary
    s.last_write_error = nil

    return {
        wrote = true,
        summary = summary,
        error = nil,
    }
end

function M.toggle_mode()
    if M.state.mode == "build" then
        M.state.mode = "plan"
    else
        M.state.mode = "build"
    end

    redraw()
    update_input_title()
end

function M.send()
    local s = session()

    if s.busy then
        notify("Ollama is still thinking", vim.log.levels.WARN)
        redraw()
        focus_input()
        return
    end

    local text = get_input_text()

    if text == "" then
        focus_input()
        return
    end

    table.insert(s.messages, {
        role = "User",
        content = text,
    })

    clear_input()

    s.busy = true

    table.insert(s.messages, {
        role = "Assistant",
        content = "Thinking...",
        pending = true,
    })

    redraw()
    focus_input()

    local prompt = main_prompt(text)

    ollama_generate(prompt, function(response, err)
        s.busy = false

        if err then
            notify(err, vim.log.levels.ERROR)
            replace_pending_message(s, "Error: " .. err)
            redraw()
            focus_input()
            return
        end

        local result = apply_replacement_files(response)
        local final_response = response

        if result.error then
            final_response = final_response
            .. "\n\n[Build write failed.]"
            .. "\n"
            .. result.error
        elseif result.wrote then
            final_response = final_response
            .. "\n\n[Build wrote files.]"
            .. "\n"
            .. result.summary
        end

        replace_pending_message(s, final_response)
        redraw()
        focus_input()
    end)
end

function M.close()
    if vim.fn.mode() ~= "n" then
        vim.cmd("stopinsert")
    end

    if M.state.input_win and vim.api.nvim_win_is_valid(M.state.input_win) then
        vim.api.nvim_win_close(M.state.input_win, false)
        M.state.input_win = nil
    end

    if M.state.chat_win and vim.api.nvim_win_is_valid(M.state.chat_win) then
        vim.api.nvim_win_close(M.state.chat_win, false)
        M.state.chat_win = nil
    end

    M.state.input_buf = nil
    M.state.chat_buf = nil

    if M.state.augroup then
        pcall(vim.api.nvim_del_augroup_by_id, M.state.augroup)
        M.state.augroup = nil
    end

    if M.state.previous_win and vim.api.nvim_win_is_valid(M.state.previous_win) then
        vim.api.nvim_set_current_win(M.state.previous_win)
    end

    vim.cmd("stopinsert")
end

local function disable_chat_editing_keys(buf)
    local disabled_normal_keys = {
        "I",
        "c",
        "C",
        "s",
        "S",
        "r",
        "R",
        "x",
        "X",
        "d",
        "D",
        "p",
        "P",
        "~",
        "=",
        "<Del>",
        "<BS>",
    }

    for _, key in ipairs(disabled_normal_keys) do
        vim.keymap.set("n", key, "<Nop>", {
            buffer = buf,
            noremap = true,
            silent = true,
            desc = "Disabled in read-only Simple Agent output",
        })
    end

    for _, key in ipairs({ "i", "a", "A", "o", "O" }) do
        vim.keymap.set("n", key, function()
            enter_input_mode()
        end, {
        buffer = buf,
        noremap = true,
        silent = true,
        desc = "Focus Simple Agent input",
    })
end

vim.keymap.set("v", "d", "y", {
    buffer = buf,
    noremap = true,
    silent = true,
    desc = "Yank selection instead of deleting in Simple Agent output",
})

vim.keymap.set("v", "x", "y", {
    buffer = buf,
    noremap = true,
    silent = true,
    desc = "Yank selection instead of deleting in Simple Agent output",
})

vim.keymap.set("v", "c", "y", {
    buffer = buf,
    noremap = true,
    silent = true,
    desc = "Yank selection instead of changing in Simple Agent output",
})

vim.keymap.set("v", "s", "y", {
    buffer = buf,
    noremap = true,
    silent = true,
    desc = "Yank selection instead of changing in Simple Agent output",
})
end

local function configure_chat_buffer(buf)
    vim.bo[buf].buftype = "nofile"
    vim.bo[buf].bufhidden = "wipe"
    vim.bo[buf].swapfile = false
    vim.bo[buf].filetype = "markdown"
    vim.bo[buf].modifiable = false
    vim.bo[buf].readonly = true

    disable_chat_editing_keys(buf)

    vim.keymap.set("n", M.config.keymap_mode_toggle, function()
        M.toggle_mode()
    end, {
    buffer = buf,
    desc = "Toggle Simple Agent mode",
})

vim.keymap.set("v", M.config.keymap_mode_toggle, function()
    vim.cmd("normal! \27")
    M.toggle_mode()
end, {
buffer = buf,
desc = "Toggle Simple Agent mode",
  })

  vim.keymap.set("n", M.config.keymap_toggle, function()
      M.close()
  end, {
  buffer = buf,
  desc = "Close Simple Agent",
  })

  vim.keymap.set("v", M.config.keymap_toggle, function()
      vim.cmd("normal! \27")
      M.close()
  end, {
  buffer = buf,
  desc = "Close Simple Agent",
  })
end

local function configure_input_buffer(buf)
    vim.bo[buf].buftype = "nofile"
    vim.bo[buf].bufhidden = "wipe"
    vim.bo[buf].swapfile = false
    vim.bo[buf].filetype = "markdown"
    vim.bo[buf].modifiable = true
    vim.bo[buf].readonly = false

    vim.keymap.set("n", "<CR>", function()
        M.send()
    end, {
    buffer = buf,
    desc = "Send Simple Agent message",
})

vim.keymap.set("i", "<CR>", function()
    vim.cmd("stopinsert")
    M.send()
end, {
buffer = buf,
desc = "Send Simple Agent message",
  })

  vim.keymap.set("n", M.config.keymap_mode_toggle, function()
      M.toggle_mode()
  end, {
  buffer = buf,
  desc = "Toggle Simple Agent mode",
  })

  vim.keymap.set("i", M.config.keymap_mode_toggle, function()
      vim.cmd("stopinsert")
      M.toggle_mode()
  end, {
  buffer = buf,
  desc = "Toggle Simple Agent mode",
  })

  vim.keymap.set("n", M.config.keymap_toggle, function()
      M.close()
  end, {
  buffer = buf,
  desc = "Close Simple Agent",
  })

  vim.keymap.set("i", M.config.keymap_toggle, function()
      M.close()
  end, {
  buffer = buf,
  desc = "Close Simple Agent",
  })
end

local function setup_autocmds()
    if M.state.augroup then
        pcall(vim.api.nvim_del_augroup_by_id, M.state.augroup)
    end

    M.state.augroup = vim.api.nvim_create_augroup("SimpleAgentFloat", {
        clear = true,
    })

    vim.api.nvim_create_autocmd({ "CursorMoved", "WinScrolled" }, {
        group = M.state.augroup,
        callback = function()
            clamp_chat_scroll()
        end,
    })

    if M.state.input_buf and vim.api.nvim_buf_is_valid(M.state.input_buf) then
        vim.api.nvim_create_autocmd("WinEnter", {
            group = M.state.augroup,
            buffer = M.state.input_buf,
            callback = function()
                scroll_chat_to_bottom()
            end,
        })
    end
end

local function open_float()
    if M.state.chat_win and vim.api.nvim_win_is_valid(M.state.chat_win) then
        redraw()
        return
    end

    setup_highlights()

    M.state.previous_win = vim.api.nvim_get_current_win()

    local total_width = math.floor(vim.o.columns * 0.82)
    local total_height = math.floor(vim.o.lines * 0.78)
    local input_height = 3
    local gap = 1
    local chat_height = total_height - input_height - gap

    if chat_height < 8 then
        chat_height = 8
    end

    local row = math.floor((vim.o.lines - total_height) / 2)
    local col = math.floor((vim.o.columns - total_width) / 2)

    local chat_buf = vim.api.nvim_create_buf(false, true)
    local input_buf = vim.api.nvim_create_buf(false, true)

    local chat_win = vim.api.nvim_open_win(chat_buf, true, {
        relative = "editor",
        row = row,
        col = col,
        width = total_width,
        height = chat_height,
        style = "minimal",
        border = "rounded",
        title = " Simple Agent ",
        title_pos = "center",
    })

    local input_win = vim.api.nvim_open_win(input_buf, true, {
        relative = "editor",
        row = row + chat_height + gap,
        col = col,
        width = total_width,
        height = input_height,
        style = "minimal",
        border = "rounded",
        title = mode_title(),
        title_pos = "center",
    })

    M.state.chat_buf = chat_buf
    M.state.chat_win = chat_win
    M.state.input_buf = input_buf
    M.state.input_win = input_win

    configure_chat_buffer(chat_buf)
    configure_input_buffer(input_buf)
    setup_autocmds()

    vim.api.nvim_buf_set_lines(input_buf, 0, -1, false, { "" })

    redraw()
    focus_input()
    vim.cmd("stopinsert")
end

function M.open()
    local ctx = current_context()

    M.state.root = ctx.root
    M.state.context_mode = ctx.mode
    M.state.context_file = ctx.file

    session()
    open_float()
end

function M.toggle()
    if M.state.chat_win and vim.api.nvim_win_is_valid(M.state.chat_win) then
        M.close()
        return
    end

    M.open()
end

vim.api.nvim_create_user_command("SimpleAgent", function()
    M.toggle()
end, {})

vim.keymap.set("n", M.config.keymap_toggle, function()
    M.toggle()
end, {
desc = "Toggle Simple Agent",
})

_G.SimpleAgent = M

return M
