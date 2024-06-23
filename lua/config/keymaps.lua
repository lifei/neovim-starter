-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("n", ";", ":", { noremap = true })
vim.keymap.set("n", "!", ":!", { noremap = true })
vim.keymap.set({ "i", "s" }, "<C-L>", function()
  local ls = require("luasnip")
  ls.change_choice(1)
end, { silent = true })
