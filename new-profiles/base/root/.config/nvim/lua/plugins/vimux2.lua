local M = {}

M.state = {
  sessions = {},
  session_names = {},
  window_names = {},
  current_session = 1,
  current_window = {},
  tab_to_meta = {},
  opts = {},
}

local defaults = {
  mappings = true,
  set_statusline = true,

  session_keys = {
    short_prefix = "M",
    overflow_prefix = "<M-0>",
  },

  window_keys = {
    short_prefix = "C",
    overflow_prefix = "<C-0>",
  },
}

local function tabpage_is_valid(tab)
  return tab and vim.api.nvim_tabpage_is_valid(tab)
end

local function tabpage_number(tab)
  if not tabpage_is_valid(tab) then
    return nil
  end

  for index, candidate in ipairs(vim.api.nvim_list_tabpages()) do
    if candidate == tab then
      return index
    end
  end

  return nil
end

local function stopinsert()
  pcall(vim.cmd, "stopinsert")
end

local function sync_current_from_tab()
  local tab = vim.api.nvim_get_current_tabpage()
  local meta = M.state.tab_to_meta[tab]

  if not meta then
    return
  end

  M.state.current_session = meta.session
  M.state.current_window[meta.session] = meta.window
end

local function go_to_tab(tab)
  local tab_number = tabpage_number(tab)

  if not tab_number then
    vim.notify("vimux2: tab no longer exists", vim.log.levels.WARN)
    return false
  end

  stopinsert()
  vim.cmd("tabnext " .. tab_number)
  sync_current_from_tab()

  return true
end

local function normalize_commands(window)
  if type(window) ~= "table" then
    error("vimux2: window must be a table with name and command/commands")
  end

  if type(window.name) ~= "string" or window.name == "" then
    error("vimux2: window must have a non-empty name")
  end

  local commands = window.commands or window.command

  if type(commands) == "string" then
    return window.name, { commands }
  end

  if type(commands) == "table" then
    return window.name, commands
  end

  error("vimux2: window " .. window.name .. " must have command or commands")
end

local function create_window(window, session_index, window_index)
  local window_name, commands = normalize_commands(window)

  for _, cmd in ipairs(commands) do
    if type(cmd) ~= "string" or cmd == "" then
      error(
        "vimux2: command for session "
          .. session_index
          .. ", window "
          .. window_index
          .. " must be a non-empty string"
      )
    end

    vim.cmd(cmd)
  end

  local tab = vim.api.nvim_get_current_tabpage()

  M.state.tab_to_meta[tab] = {
    session = session_index,
    window = window_index,
    command = table.concat(commands, " && "),
  }

  return tab, window_name
end

local function close_original_tab(original_tab)
  if not tabpage_is_valid(original_tab) then
    return
  end

  if M.state.tab_to_meta[original_tab] then
    return
  end

  if #vim.api.nvim_list_tabpages() <= 1 then
    return
  end

  local original_tab_number = tabpage_number(original_tab)

  if original_tab_number then
    vim.cmd("tabclose " .. original_tab_number)
  end
end

function M.current()
  sync_current_from_tab()

  local session_index = M.state.current_session
  local window_index = M.state.current_window[session_index] or 1
  local session = M.state.sessions[session_index]
  local tab = session and session[window_index] or nil
  local meta = tab and M.state.tab_to_meta[tab] or nil

  return {
    session = session_index,
    window = window_index,
    tab = tab,
    meta = meta,
  }
end

function M.switch_session(session_index)
  stopinsert()

  session_index = tonumber(session_index)

  if not session_index then
    return
  end

  local session = M.state.sessions[session_index]

  if not session then
    vim.notify("vimux2: no session " .. tostring(session_index), vim.log.levels.WARN)
    return
  end

  local window_index = M.state.current_window[session_index] or 1
  local tab = session[window_index]

  if not tabpage_is_valid(tab) then
    tab = session[1]
    window_index = 1
  end

  if not tabpage_is_valid(tab) then
    vim.notify("vimux2: session " .. session_index .. " has no valid tabs", vim.log.levels.WARN)
    return
  end

  if go_to_tab(tab) then
    M.state.current_session = session_index
    M.state.current_window[session_index] = window_index
  end
end

function M.switch_window(window_index)
  stopinsert()

  window_index = tonumber(window_index)

  if not window_index then
    return
  end

  sync_current_from_tab()

  local session_index = M.state.current_session
  local session = M.state.sessions[session_index]

  if not session then
    vim.notify("vimux2: no current session", vim.log.levels.WARN)
    return
  end

  local tab = session[window_index]

  if not tabpage_is_valid(tab) then
    vim.notify(
      "vimux2: no window " .. tostring(window_index) .. " in session " .. tostring(session_index),
      vim.log.levels.WARN
    )
    return
  end

  if go_to_tab(tab) then
    M.state.current_window[session_index] = window_index
  end
end

function M.next_session()
  stopinsert()
  sync_current_from_tab()

  local count = #M.state.sessions

  if count == 0 then
    return
  end

  local next_index = M.state.current_session + 1

  if next_index > count then
    next_index = 1
  end

  M.switch_session(next_index)
end

function M.prev_session()
  stopinsert()
  sync_current_from_tab()

  local count = #M.state.sessions

  if count == 0 then
    return
  end

  local prev_index = M.state.current_session - 1

  if prev_index < 1 then
    prev_index = count
  end

  M.switch_session(prev_index)
end

function M.next_window()
  stopinsert()
  sync_current_from_tab()

  local session_index = M.state.current_session
  local session = M.state.sessions[session_index]

  if not session then
    return
  end

  local current = M.state.current_window[session_index] or 1
  local next_index = current + 1

  if next_index > #session then
    next_index = 1
  end

  M.switch_window(next_index)
end

function M.prev_window()
  stopinsert()
  sync_current_from_tab()

  local session_index = M.state.current_session
  local session = M.state.sessions[session_index]

  if not session then
    return
  end

  local current = M.state.current_window[session_index] or 1
  local prev_index = current - 1

  if prev_index < 1 then
    prev_index = #session
  end

  M.switch_window(prev_index)
end

function M.statusline_prefix()
  local current = M.current()

  if not current or not current.session or not current.window then
    return ""
  end

  local session_name = M.state.session_names[current.session]
  local window_name = M.state.window_names[current.session]
    and M.state.window_names[current.session][current.window]

  if not session_name or not window_name then
    return ""
  end

  return string.format(
    "[%s:%d] [%s:%d]",
    session_name,
    current.session,
    window_name,
    current.window
  )
end

local function current_window_cwd()
  return vim.fn.fnamemodify(vim.fn.getcwd(0), ":~")
end

function M.statusline()
  local prefix = M.statusline_prefix()

  if prefix ~= "" then
    prefix = prefix .. " "
  end

  if vim.bo.filetype == "oil" then
    return prefix .. "oil " .. current_window_cwd()
  end

  if vim.bo.buftype == "terminal" then
    return prefix .. "term " .. current_window_cwd()
  end

  return prefix .. vim.fn.expand("%")
end

local function map(lhs, rhs, desc)
  vim.keymap.set("n", lhs, rhs, {
    silent = true,
    desc = desc,
  })

  vim.keymap.set("t", lhs, rhs, {
    silent = true,
    desc = desc,
  })
end

local function key(prefix, n)
  return "<" .. prefix .. "-" .. tostring(n) .. ">"
end

local function setup_mappings()
  for i = 1, 9 do
    map(key(M.state.opts.session_keys.short_prefix, i), function()
      M.switch_session(i)
    end, "Switch vimux2 session " .. i)

    map(key(M.state.opts.window_keys.short_prefix, i), function()
      M.switch_window(i)
    end, "Switch vimux2 window " .. i)
  end

  for overflow = 1, 9 do
    local index = overflow + 9

    map(M.state.opts.session_keys.overflow_prefix .. tostring(overflow), function()
      M.switch_session(index)
    end, "Switch vimux2 session " .. index)

    map(M.state.opts.window_keys.overflow_prefix .. tostring(overflow), function()
      M.switch_window(index)
    end, "Switch vimux2 window " .. index)
  end

  map("<M-j>", M.prev_session, "Previous vimux2 session")
  map("<M-k>", M.next_session, "Next vimux2 session")

  map("<C-j>", M.prev_window, "Previous vimux2 window")
  map("<C-k>", M.next_window, "Next vimux2 window")
end

local function validate_session(session, session_index)
  if type(session) ~= "table" then
    error("vimux2: session " .. session_index .. " must be a table")
  end

  if type(session.name) ~= "string" or session.name == "" then
    error("vimux2: session " .. session_index .. " must have a non-empty name")
  end

  if type(session.windows) ~= "table" then
    error("vimux2: session " .. session_index .. " must have a windows table")
  end

  if #session.windows == 0 then
    error("vimux2: session " .. session_index .. " must have at least one window")
  end
end

function M.setup(opts)
  M.state.opts = vim.tbl_deep_extend("force", defaults, opts or {})

  local layout = M.state.opts.layout or {}

  if #layout == 0 then
    vim.notify("vimux2: no sessions configured", vim.log.levels.WARN)
    return
  end

  M.state.sessions = {}
  M.state.session_names = {}
  M.state.window_names = {}
  M.state.current_window = {}
  M.state.tab_to_meta = {}

  local original_tab = vim.api.nvim_get_current_tabpage()

  for session_index, session in ipairs(layout) do
    validate_session(session, session_index)

    M.state.session_names[session_index] = session.name
    M.state.sessions[session_index] = {}
    M.state.current_window[session_index] = 1

    M.state.window_names[session_index] = {}

    for window_index, window in ipairs(session.windows) do
      local tab, window_name = create_window(window, session_index, window_index)

      M.state.sessions[session_index][window_index] = tab
      M.state.window_names[session_index][window_index] = window_name
    end
  end

  close_original_tab(original_tab)

  vim.api.nvim_create_autocmd("TabEnter", {
    group = vim.api.nvim_create_augroup("Vimux2", { clear = true }),
    callback = sync_current_from_tab,
  })

  if M.state.opts.mappings then
    setup_mappings()
  end

  vim.o.statusline = "%{%v:lua.require'plugins.vimux2'.statusline()%} %m %= %l:%c"

  M.switch_session(1)
end

return M
