-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("n", ";", ":", { noremap = true })
vim.keymap.set("n", "!", ":!", { noremap = true })
vim.keymap.set({ "i", "s" }, "<C-L>", function()
  local ls = require("luasnip")
  ls.change_choice(1)
end, { silent = true })


local paste = function()
  local lines = vim.fn.getreg("+")
  vim.api.nvim_paste(lines, false, -1)
end
local topts = { silent = true }
local opts = { silent = true, noremap = true }

vim.keymap.set({ "i", "c", "l" }, "<D-v>",   paste, opts)
vim.keymap.set({ "i", "c", "l" }, "<M-v>",   paste, opts)
vim.keymap.set({ "i", "c", "l" }, "<C-v>",   paste, opts)
vim.keymap.set({ "i", "c", "l" }, "<S-Ins>", paste, opts)

vim.keymap.set({ "t" }, "<D-v>", paste, topts)
vim.keymap.set({ "t" }, "<M-v>", paste, topts)
vim.keymap.set({ "t" }, "<C-v>", paste, topts)

vim.keymap.set({ "n" }, "<D-v>",    paste, opts)
vim.keymap.set({ "n" }, "<M-v>",    paste, opts)
vim.keymap.set({ "n" }, "<S-Ins>",  paste, opts)

vim.keymap.set({ "v" }, "<D-c>", '"+y')
vim.keymap.set({ "v" }, "<M-c>", '"+y')
vim.keymap.set({ "v" }, "<C-c>", '"+y')
vim.keymap.set({ "v" }, "<C-Ins>", '"+y')

vim.keymap.set({ "v" }, "<leader>r`", "di``<ESC>P", { desc = "Surround with `" })
vim.keymap.set({ "v" }, "<leader>r'", "di''<ESC>P", { desc = "Surround with '" })
vim.keymap.set({ "v" }, '<leader>r"', 'di""<ESC>P', { desc = 'Surround with "' })
vim.keymap.set({ "v" }, "<leader>r(", "di()<ESC>P", { desc = "Surround with ()" })
vim.keymap.set({ "v" }, "<leader>r[", "di[]<ESC>P", { desc = "Surround with []" })

vim.keymap.set({ "n" }, "<tab>", "<C-W>w")
