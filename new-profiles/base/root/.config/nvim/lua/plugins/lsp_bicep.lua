local M = {}

M.setup = function()
  vim.filetype.add({
    extension = {
      bicep = "bicep",
      bicepparam = "bicep-params",
    },
  })

  vim.lsp.config("bicep", {
    cmd = {
      "dotnet",
      "/opt/bicep-langserver/Bicep.LangServer.dll",
    },

    filetypes = {
      "bicep",
      "bicep-params",
    },

    root_markers = {
      "bicepconfig.json",
      ".git",
    },
  })

  vim.lsp.enable("bicep")
end

return M
