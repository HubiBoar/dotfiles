local M = {}

M.setup = function()
    vim.lsp.config("yamlls", {
      cmd = { "yaml-language-server", "--stdio" },
      filetypes = { "yaml", "yaml.docker-compose", "yaml.github" },
      settings = {
        yaml = {
          validate = true,
          completion = true,
          hover = true,
          schemas = {
            ["https://json.schemastore.org/github-workflow.json"] = {
              ".github/workflows/*.yml",
              ".github/workflows/*.yaml",
            },
            ["https://json.schemastore.org/github-action.json"] = {
              "action.yml",
              "action.yaml",
            },
          },
        },
      },
    })

    vim.lsp.enable("yamlls")
end

return M
