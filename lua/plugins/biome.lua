return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      local has_biome_config = vim.fs.find({ "biome.json", "rome.json" }, { upward = true })[1]

      if not has_biome_config then
        if opts.servers and opts.servers.biome then
          opts.servers.biome = nil
        end
        return opts
      end

      opts.servers = opts.servers or {}
      opts.servers.biome = {} -- Use default settings
      return opts
    end,
  },
}
