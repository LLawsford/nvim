return {
  {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    ft = { "typescript", "typescriptreact", "typescript.tsx", "javascript", "javascriptreact", "javascript.jsx" },
    opts = {
      on_attach = function(client, bufnr)
        -- HACK: Set a longer timeout for tsserver requests.
        -- The default (1-3s) is too short for large files.
        -- Value is in milliseconds.
        client.timeout = 10000 -- 10 seconds
      end,
      -- PERFORMANCE-FRIENDLY SETTINGS
      settings = {
        -- run a separate diag server so edits stay snappy
        separate_diagnostic_server = true,
        -- don't publish diagnostics on every keystroke
        publish_diagnostic_on = "insert_leave",
        -- expose useful fixes as code actions
        expose_as_code_action = { "add_missing_imports", "remove_unused" },
                -- give tsserver more heap (20 * 1024)
        tsserver_max_memory = 20480,

        -- preferences that cut noise and speed things up
        tsserver_file_preferences = {
          includeInlayParameterNameHints = "none",
          includeInlayParameterNameHintsWhenArgumentMatchesName = false,
          includeInlayFunctionParameterTypeHints = false,
          includeInlayVariableTypeHints = false,
          includeInlayPropertyDeclarationTypeHints = false,
          includeInlayFunctionLikeReturnTypeHints = false,
          includeInlayEnumMemberValueHints = false,

          includeCompletionsForModuleExports = true,
          includeCompletionsWithInsertTextCompletions = true,
          includeAutomaticOptionalChainCompletions = true,
          includePackageJsonAutoImports = "on",
          -- limit massive completion payloads
          defaultImportModuleSpecifierPreference = "shortest",
        },

        tsserver_format_options = {
          semicolons = "insert",
        },
      },

      -- OPTIONAL: a few handy commands are provided by the plugin already:
      -- :TSToolsOrganizeImports
      -- :TSToolsAddMissingImports
      -- :TSToolsRemoveUnused
      -- :TSToolsFixAll
    },
  },

  -- Keep lspconfig for every other server, but disable TS servers so they don't clash
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers = opts.servers or {}

      -- make sure these do NOT start (we're using typescript-tools instead)
      opts.servers.vtsls = { enabled = false }
      opts.servers.tsserver = { enabled = false }
      opts.servers.ts_ls = { enabled = false }

      -- DO NOT touch eslint/tailwindcss/etc; they stay as-is via LazyVim defaults or your other plugin files

      -- clean up any prior setup hooks for vtsls
      opts.setup = opts.setup or {}
      opts.setup.vtsls = function()
        return true
      end
      opts.setup.tsserver = function()
        return true
      end
      opts.setup.ts_ls = function()
        return true
      end
      opts.setup["typescript-tools"] = function()
        return true
      end

      return opts
    end,
  },

  -- OPTIONAL: organize + basic fixes on save (fast; uses typescript-tools commands)
  {
    "folke/lazy.nvim",
    optional = true,
    init = function()
      local grp = vim.api.nvim_create_augroup("TsToolsOnSave", { clear = true })
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = grp,
        pattern = { "*.ts", "*.tsx", "*.js", "*.jsx" },
        callback = function()
          -- these are synchronous-ish and lightweight compared to ESLint LSP onType
          -- pcall(vim.cmd, "silent! TSToolsAddMissingImports")
          -- pcall(vim.cmd, "silent! TSToolsOrganizeImports")
          -- If you want the big hammer:
          -- pcall(vim.cmd, "silent! TSToolsFixAll")
        end,
      })
    end,
  },
}
