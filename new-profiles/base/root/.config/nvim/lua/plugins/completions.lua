local M = {}

M.setup = function()
  vim.opt.completeopt = { "menuone", "popup", "noinsert", "fuzzy" }

  local keys = require("../keys").completions()

  for lhs, rhs in pairs(keys) do
    vim.keymap.set("i", lhs, rhs, {
      expr = lhs == "<CR>",
      silent = true,
      desc = "Native LSP completion",
    })
  end

  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("NativeLspCompletion", { clear = true }),
    callback = function(ev)
      local client = vim.lsp.get_client_by_id(ev.data.client_id)
      if not client then
        return
      end

      if client:supports_method(vim.lsp.protocol.Methods.textDocument_completion) then
        vim.lsp.completion.enable(true, client.id, ev.buf, {
          autotrigger = false,
        })
      end
    end,
  })
end

return M
