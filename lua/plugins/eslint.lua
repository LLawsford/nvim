return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers = opts.servers or {}
      opts.servers.eslint = opts.servers.eslint or {}

      -- Default ESLint LSP settings: avoid formatting conflicts and auto-detect cwd
      opts.servers.eslint.settings = vim.tbl_deep_extend(
        "force",
        {
          workingDirectory = { mode = "auto" },
          format = false, -- leave formatting to your formatter (e.g. Prettier)
        },
        opts.servers.eslint.settings or {}
      )

      opts.setup = opts.setup or {}
      local previous_setup = opts.setup.eslint

      opts.setup.eslint = function(server, server_opts)
        local util = require("lspconfig.util")
        local uv = vim.uv or vim.loop

        local function file_exists(path)
          return path and uv.fs_stat(path) ~= nil
        end

        local function has_flat(root)
          if not root or root == "" then
            return false
          end
          local candidates = {
            "eslint.config.js",
            "eslint.config.cjs",
            "eslint.config.mjs",
            "eslint.config.ts",
          }
          for _, f in ipairs(candidates) do
            if file_exists(root .. "/" .. f) then
              return true
            end
          end
          return false
        end

        local prev_on_new_config = server_opts.on_new_config
        server_opts.on_new_config = function(new_config, root_dir)
          if prev_on_new_config then
            pcall(prev_on_new_config, new_config, root_dir)
          end
          new_config.settings = new_config.settings or {}
          new_config.settings.experimental = new_config.settings.experimental or {}
          new_config.settings.workingDirectory = new_config.settings.workingDirectory or { mode = "auto" }
          new_config.settings.format = false
          new_config.settings.experimental.useFlatConfig = has_flat(root_dir)
        end

        -- Chain to any previous custom setup if present
        if previous_setup then
          return previous_setup(server, server_opts)
        end
        return false -- continue with default setup
      end

      return opts
    end,
  },
}

