return {
  {
    "nvim-telescope/telescope.nvim",
    opts = function(_, opts)
      opts = opts or {}
      opts.defaults = opts.defaults or {}
      opts.pickers = opts.pickers or {}

      -- Show hidden and gitignored files (e.g. .env) in file picker
      local find_cmd
      if vim.fn.executable("fd") == 1 then
        find_cmd = { "fd", "--type", "f", "--hidden", "--strip-cwd-prefix", "--exclude", ".git" }
      else
        find_cmd = { "rg", "--files", "--hidden", "--no-ignore-vcs", "--glob", "!**/.git/*" }
      end

      opts.pickers.find_files = vim.tbl_deep_extend("force", opts.pickers.find_files or {}, {
        hidden = true,
        no_ignore = true, -- include files ignored by .gitignore/.ignore
        follow = true,
        -- keep ignoring the .git directory to avoid noise
        find_command = find_cmd,
      })

      -- Make live_grep/grep_string also search hidden + gitignored files, but still skip .git
      local add_hidden_args = function()
        return { "--hidden", "--no-ignore-vcs", "--glob", "!**/.git/*" }
      end
      opts.pickers.live_grep = vim.tbl_deep_extend("force", opts.pickers.live_grep or {}, {
        additional_args = add_hidden_args,
      })
      opts.pickers.grep_string = vim.tbl_deep_extend("force", opts.pickers.grep_string or {}, {
        additional_args = add_hidden_args,
      })

      return opts
    end,
  },
}
