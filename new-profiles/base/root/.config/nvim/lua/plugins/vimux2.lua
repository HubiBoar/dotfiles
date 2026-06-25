local M = {}

M.state = {
  sessions = {},
  current_session = 1,
  current_window = {},
  tab_to_meta = {},
  opts = {},
}

local defaults = {
  mappings = true,

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

  for i, candidate in ipairs(vim.api.nvim_list_tabpages()) do
    if candidate == tab then
      return i
    end
  end

  return nil
end

local function go_to_tab(tab)
  local n = tabpage_number(tab)

  if not n then
    vim.notify("tmux-tabs: tab no longer exists", vim.log.levels.WARN)
    return false
  end

  vim.cmd("tabnext " .. n)
  return true
end

local function detect_kind(command)
  if command:find("Oil") then
    return "Oil"
  end

  if command:find("terminal") then
    return "Terminal"
  end

  return "Tab"
end

local function get_tab_cwd()
  local ok, cwd = pcall(vim.fn.getcwd, -1, -1)

  if ok and cwd and cwd ~= "" then
    return vim.fn.fnamemodify(cwd, ":~")
  end

  return ""
end

local function create_window(command, session_index, window_index)
  vim.cmd(command)

  local tab = vim.api.nvim_get_current_tabpage()

  M.state.tab_to_meta[tab] = {
    session = session_index,
    window = window_index,
    kind = detect_kind(command),
    command = command,
    cwd = get_tab_cwd(),
  }

  return tab
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
  vim.cmd("stopinsert")
  session_index = tonumber(session_index)

  local session = M.state.sessions[session_index]

  if not session then
    vim.notify("tmux-tabs: no session " .. tostring(session_index), vim.log.levels.WARN)
    return
  end

  local window_index = M.state.current_window[session_index] or 1
  local tab = session[window_index]

  if not tabpage_is_valid(tab) then
    tab = session[1]
    window_index = 1
  end

  if not tabpage_is_valid(tab) then
    vim.notify("tmux-tabs: session " .. session_index .. " has no valid tabs", vim.log.levels.WARN)
    return
  end

  if go_to_tab(tab) then
    M.state.current_session = session_index
    M.state.current_window[session_index] = window_index
  end
end

function M.switch_window(window_index)
  vim.cmd("stopinsert")
  window_index = tonumber(window_index)

  sync_current_from_tab()

  local session_index = M.state.current_session
  local session = M.state.sessions[session_index]

  if not session then
    vim.notify("tmux-tabs: no current session", vim.log.levels.WARN)
    return
  end

  local tab = session[window_index]

  if not tabpage_is_valid(tab) then
    vim.notify(
      "tmux-tabs: no window " .. tostring(window_index) .. " in session " .. tostring(session_index),
      vim.log.levels.WARN
    )
    return
  end

  if go_to_tab(tab) then
    M.state.current_window[session_index] = window_index
  end
end

function M.next_session()
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

function M.statusline()
  local current = M.current()
  local meta = current.meta

  if not meta then
    return ""
  end

  return string.format(
    "[%d] [%d] [%s] %s",
    current.session,
    current.window,
    meta.kind,
    meta.cwd or get_tab_cwd()
  )
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
    end, "Switch tmux-tabs session " .. i)

    map(key(M.state.opts.window_keys.short_prefix, i), function()
      M.switch_window(i)
    end, "Switch tmux-tabs window " .. i)
  end

  for overflow = 1, 9 do
    local index = overflow + 9

    map(M.state.opts.session_keys.overflow_prefix .. tostring(overflow), function()
      M.switch_session(index)
    end, "Switch tmux-tabs session " .. index)

    map(M.state.opts.window_keys.overflow_prefix .. tostring(overflow), function()
      M.switch_window(index)
    end, "Switch tmux-tabs window " .. index)
  end

  map("<M-j>", M.prev_session, "Previous tmux-tabs session")
  map("<M-k>", M.next_session, "Next tmux-tabs session")

  map("<C-j>", M.prev_window, "Previous tmux-tabs window")
  map("<C-k>", M.next_window, "Next tmux-tabs window")
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

  local n = tabpage_number(original_tab)
  if n then
    vim.cmd("tabclose " .. n)
  end
end

function M.setup(opts)
  M.state.opts = vim.tbl_deep_extend("force", defaults, opts or {})

  local layout = M.state.opts.layout or M.state.opts.sessions or {}

  if #layout == 0 then
    vim.notify("tmux-tabs: no sessions configured", vim.log.levels.WARN)
    return
  end

  M.state.sessions = {}
  M.state.current_window = {}
  M.state.tab_to_meta = {}

  local original_tab = vim.api.nvim_get_current_tabpage()

  for session_index, session in ipairs(layout) do
    M.state.sessions[session_index] = {}
    M.state.current_window[session_index] = 1

    for window_index, command in ipairs(session) do
      local tab = create_window(command, session_index, window_index)
      M.state.sessions[session_index][window_index] = tab
    end
  end

  close_original_tab(original_tab)

  vim.api.nvim_create_autocmd("TabEnter", {
    group = vim.api.nvim_create_augroup("TmuxTabs", { clear = true }),
    callback = sync_current_from_tab,
  })

  if M.state.opts.mappings then
    setup_mappings()
  end

  M.switch_session(1)
end

return M
