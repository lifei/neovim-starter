-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("n", ";", ":", { noremap = true })
vim.keymap.set("n", "!", ":!", { noremap = true })
vim.keymap.set({ "i", "s" }, "<C-L>", function()
  local ls = require("luasnip")
  ls.change_choice(1)
end, { silent = true })

vim.keymap.set({ "i", "c", "l" }, "<D-v>", "<C-R>+")
vim.keymap.set({ "i", "c", "l" }, "<M-v>", "<C-R>+")
vim.keymap.set({ "i", "c", "l" }, "<C-v>", "<C-R>+")
vim.keymap.set({ "i", "c", "l" }, "<S-Ins>", "<C-R>+")

vim.keymap.set({ "n" }, "<D-v>", '"+p')
vim.keymap.set({ "n" }, "<M-v>", '"+p')
vim.keymap.set({ "n" }, "<S-Ins>", '"+p')

vim.keymap.set({ "v" }, "<D-c>", '"+y')
vim.keymap.set({ "v" }, "<M-c>", '"+y')
vim.keymap.set({ "v" }, "<C-c>", '"+y')
vim.keymap.set({ "v" }, "<C-Ins>", '"+y')

vim.keymap.set({ "v" }, "<leader>r`", "di``<ESC>P", { desc = "Surround with `" })
vim.keymap.set({ "v" }, "<leader>r'", "di''<ESC>P", { desc = "Surround with '" })
vim.keymap.set({ "v" }, '<leader>r"', 'di""<ESC>P', { desc = 'Surround with "' })
vim.keymap.set({ "v" }, "<leader>r(", "di()<ESC>P", { desc = "Surround with ()" })
vim.keymap.set({ "v" }, "<leader>r[", "di[]<ESC>P", { desc = "Surround with []" })
