local config = {
  -- { 'folke/trouble.nvim', enabled = false },
  -- { 'bufferline.nvim', enabled = false },
  -- { 'flash.nvim', enabled = false },
  -- { 'gruvbox.nvim', enabled = false },
  -- { 'lazy.nvim', enabled = false },
  -- { 'LazyVim', enabled = false },
  -- { 'lualine.nvim', enabled = false },
  -- { 'mini.ai', enabled = false },
  -- { 'mini.comment', enabled = false },
  -- { 'mini.pairs', enabled = false },
  -- { 'mini.starter', enabled = false },
  -- { 'noice.nvim', enabled = false },
  -- { 'nui.nvim', enabled = false },
  -- { 'nvim-notify', enabled = false },
  -- { 'nvim-web-devicons', enabled = false },
  -- { 'which-key.nvim', enabled = false },
  { "nvim-ts-autotag", enabled = false },
  -- { 'nvim-tree.lua', enabled = false },
  -- { 'neo-tree.vim', enabled = false },
  -- { 'nvim-treesitter', enabled = false },
  -- { 'nvim-treesitter-textobjects', enabled = false },
}
if vim.fn.has("win32") == 1 then
  table.insert(config, { "nvim-telescope/telescope-fzf-native.nvim", enabled = false })
end
return config
