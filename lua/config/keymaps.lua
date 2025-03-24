-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.keymap.set("i", "kj", "<esc>", { desc = "Exit insert mode" })

-- Sneak setup
vim.g["sneak#label"] = 1  -- Enable sneak label
vim.g["sneak#use_ic_scs"] = 1  -- Case sensitivity in sneak searches

vim.api.nvim_set_keymap('n', 'f', '<Plug>Sneak_s', {})
vim.api.nvim_set_keymap('n', 'F', '<Plug>Sneak_S', {})

vim.keymap.set("n", "gr", function()
  require("telescope.builtin").lsp_references({ include_declaration = false })
end, { desc = "LSP References (Exclude Declarations)" })
