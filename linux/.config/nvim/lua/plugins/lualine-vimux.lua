return
{
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },

    config = function ()
        --require('lualine').setup({
        --  tabline = {
        --    lualine_a = {
        --      {
        --        'tabs',
        --        mode = 0 -- 0: Shows tab name
        --                  -- 1: Shows tab index
        --                  -- 2: Shows tab name + index
        --        --fmt = function(name, context)
        --        --  -- Lualine's context.tabnr is an index (1, 2, 3). 
        --        --  -- We need to convert that index into a real Tab Handle.
        --        --  local tab_handle = vim.api.nvim_list_tabpages()[context.tabnr]

        --        --  if tab_handle then
        --        --    -- Use nvim_tabpage_get_var to safely fetch the name from that specific handle
        --        --    local success, tab_name = pcall(vim.api.nvim_tabpage_get_var, tab_handle, 'tab_name')
        --        --    if success and tab_name and tab_name ~= "" then
        --        --      return tab_name
        --        --    end
        --        --  end

        --        --  return name
        --        --end
        --      }
        --    },
        --  }
        --})
        require('lualine').setup {
          -- sections = {
          --   lualine_a = { 'mode' },
          --   lualine_b = { 'branch' },
          --   -- Add the tabs component here:
          --   lualine_c = {
          --     {
          --       'tabs',
          --       mode = 0, -- 0 displays tab index only
          --       max_length = vim.o.columns / 3,
          --       tabs_color = {
          --         active = { fg = '#ffffff', gui = 'bold' },
          --         inactive = { fg = '#888888' },
          --       },
          --     }
          --   },
          -- },
        }
    end,
}
