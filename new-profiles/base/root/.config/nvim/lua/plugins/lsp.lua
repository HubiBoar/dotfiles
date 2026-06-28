local M = {}

M.pack = {
  src = "https://github.com/neovim/nvim-lspconfig",
  version = "a4ed4e761c400849e8c9f8bda33e5083f890268c",
}

M.setup = function()

    require("../keys").lsp()
    vim.diagnostic.config(
    {
        virtual_text = false
    })

    vim.api.nvim_create_user_command("LspKill", function(opts)
      local name = opts.args

      for _, client in ipairs(vim.lsp.get_clients({ name = name })) do
        client:stop(true)
      end
    end, {
      nargs = 1,
      complete = function()
        local names = {}

        for _, client in ipairs(vim.lsp.get_clients()) do
          names[client.name] = true
        end

        return vim.tbl_keys(names)
      end,
    })

end

return M
