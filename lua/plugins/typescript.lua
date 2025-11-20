return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers = opts.servers or {}

      opts.servers.vtsls = { enabled = false }
      opts.servers.tsserver = { enabled = false }
      opts.servers.ts_ls = { enabled = false }

      opts.servers.tsgo = {
        cmd = { "tsgo", "--lsp", "--stdio" },
        filetypes = {
          "javascript",
          "javascriptreact",
          "javascript.jsx",
          "typescript",
          "typescriptreact",
          "typescript.tsx",
        },
        root_markers = {
          "tsconfig.json",
          "jsconfig.json",
          "package.json",
          ".git",
          "tsconfig.base.json",
        },
      }

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

      return opts
    end,
  },
}
