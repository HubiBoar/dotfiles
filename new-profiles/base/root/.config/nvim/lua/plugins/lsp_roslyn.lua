local M = {}

M.setup = function()

    vim.lsp.config("roslyn_ls", {
      cmd = { "roslyn-language-server", "--stdio" },

      filetypes = { "cs", "razor" },

      root_markers = {
        "*.sln",
        "*.slnx",
        "*.csproj",
        ".git",
      },

      settings = {
        ["csharp|background_analysis"] = {
          dotnet_analyzer_diagnostics_scope = "openFiles",
          dotnet_compiler_diagnostics_scope = "openFiles",
        },
      },
    })

    vim.lsp.enable("roslyn_ls")

end

return M;
