return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      local eslint_configs = {
        ".eslintrc",
        ".eslintrc.js",
        ".eslintrc.cjs",
        ".eslintrc.yaml",
        ".eslintrc.yml",
        ".eslintrc.json",
        "eslint.config.js",
        "eslint.config.cjs",
        "eslint.config.mjs",
        "eslint.config.ts",
      }
      local has_eslint_config = vim.fs.find(eslint_configs, { upward = true })[1]
      local has_eslint_pkg_config = false
      if not has_eslint_config then
        local pkg_json = vim.fs.find("package.json", { upward = true })[1]
        if pkg_json then
          local f = io.open(pkg_json, "r")
          if f then
            local content = f:read("*a")
            f:close()
            if content and string.find(content, '"eslintConfig"') then
              has_eslint_pkg_config = true
            end
          end
        end
      end

      if not (has_eslint_config or has_eslint_pkg_config) then
        if opts.servers and opts.servers.eslint then
          opts.servers.eslint = nil
        end
        return opts
      end

      opts.servers = opts.servers or {}
      opts.servers.eslint = opts.servers.eslint or {}

      opts.servers.eslint.settings = vim.tbl_deep_extend(
        "force",
        {
          workingDirectory = { mode = "auto" },
          format = false,
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

        if previous_setup then
          return previous_setup(server, server_opts)
        end
        return false
      end

      return opts
    end,
  },
}

