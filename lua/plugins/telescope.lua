return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "andrew-george/telescope-themes",
    },
    keys = {

      -- add a keymap to browse plugin files
      -- stylua: ignore
      {
        "<leader>fp",
        function() require("telescope.builtin").find_files({ cwd = require("lazy.core.config").options.root }) end,
        desc = "Find Plugin File",
      },
    },
    -- change some options
    opts = {
      defaults = {
    layout_config = {
      vertical = { width = 0.9 }
      -- other layout configuration here
    },
        sorting_strategy = "ascending",
        winblend = 0,
      },
    },
  },
}
