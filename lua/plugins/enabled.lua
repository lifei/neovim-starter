-- since this is just an example spec, don"t actually load anything here and return an empty spec
-- stylua: ignore
-- if true then return {} end

-- every spec file under the "plugins" directory will be loaded automatically by lazy.nvim
--
-- In your plugin files, you can:
-- * add extra plugins
-- * disable/enabled LazyVim plugins
-- * override the configuration of LazyVim plugins
local config = {

  -- the colorscheme should be available when starting Neovim
  {
    "folke/tokyonight.nvim", -- "folke/tokyonight.nvim"
    lazy = false,            -- make sure we load this during startup if it is your main colorscheme
    priority = 1000,         -- make sure to load this before all the other start plugins
    config = function()
      -- load the colorscheme here
      vim.cmd([[colorscheme tokyonight]])
    end,
  },

  {
    "folke/flash.nvim",
    keys = {
      -- disable the default flash keymap
      { "s", mode = { "n", "x", "o" }, false },
      { "S", mode = { "n", "x", "o" }, false },
    },
  },

  {
    "bufferline.nvim",
    branch = "main",
    opts = {
      options = {
        indicator = {
          icon = "🚩", -- this should be omitted if indicator style is not "icon"
          style = "icon",
        },
      },
    },
  },

  {
    "ojroques/nvim-lspfuzzy",
    dependencies = {
      {"junegunn/fzf"},
      {"junegunn/fzf.vim"},  -- to enable preview (optional)
    },
    main = "lspfuzzy",
  },

  {
    "akinsho/toggleterm.nvim",
    version = "*",
    event = "VeryLazy",
    keys = {
      { "<leader>t", "<cmd>ToggleTerm cmd='exec bash -l'<cr>", desc="Toggle Term" },
    },
  },
}

return config

-- vim600: foldmethod=marker
