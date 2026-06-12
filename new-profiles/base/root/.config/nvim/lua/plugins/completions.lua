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
    vim.keymap.set("i", "<Down>", function()
      if vim.fn.pumvisible() == 1 then
        return "<C-n>"
      end
      return "<Down>"
    end, { expr = true })

    vim.keymap.set("i", "<Up>", function()
      if vim.fn.pumvisible() == 1 then
        return "<C-p>"
      end
      return "<Up>"
    end, { expr = true })
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
