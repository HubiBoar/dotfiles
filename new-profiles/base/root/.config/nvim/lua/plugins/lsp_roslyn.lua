local M = {}

M.setup = function()
  --local overloads = require("plugins.lspoverloads")

  vim.lsp.config("roslyn_ls", {
    cmd = { "roslyn-language-server", "--stdio" },

    filetypes = { "cs" },

    root_markers = {
      "*.csproj",
      "*.sln",
      "*.slnx",
    },

    flags = {
      debounce_text_changes = 250,
      allow_incremental_sync = true,
    },

    settings = {
      ["csharp|background_analysis"] = {
        dotnet_analyzer_diagnostics_scope = "openFiles",
        dotnet_compiler_diagnostics_scope = "openFiles",
      },

      ["csharp|completion"] = {
        dotnet_provide_regex_completions = false,
      },

      ["csharp|code_lens"] = {
        dotnet_enable_references_code_lens = false,
        dotnet_enable_tests_code_lens = false,
      },

      ["csharp|inlay_hints"] = {
        csharp_enable_inlay_hints_for_implicit_object_creation = false,
        csharp_enable_inlay_hints_for_implicit_variable_types = false,
        csharp_enable_inlay_hints_for_lambda_parameter_types = false,
        csharp_enable_inlay_hints_for_types = false,
      },
    },

    on_attach = function(client, bufnr)
      client.server_capabilities.semanticTokensProvider = nil
      --overloads.setup("roslyn", client, bufnr)
    end,
  })

  local roslyn_restart_timer = nil

  vim.api.nvim_create_autocmd("BufWritePost", {
    pattern = "*.cs",
    callback = function(args)
      vim.diagnostic.reset(nil, args.buf)

      local clients = vim.lsp.get_clients({
        name = "roslyn_ls",
        bufnr = args.buf,
      })

      if #clients == 0 then
        return
      end

      if roslyn_restart_timer then
        roslyn_restart_timer:stop()
        roslyn_restart_timer:close()
      end

      roslyn_restart_timer = vim.uv.new_timer()

      roslyn_restart_timer:start(300, 0, vim.schedule_wrap(function()
        roslyn_restart_timer:stop()
        roslyn_restart_timer:close()
        roslyn_restart_timer = nil

        vim.lsp.enable("roslyn_ls", false)

        vim.defer_fn(function()
          vim.lsp.enable("roslyn_ls", true)
        end, 100)
      end))
    end,
  })

  vim.lsp.enable("roslyn_ls")

  vim.lsp.enable("roslyn_ls")
end

return M
