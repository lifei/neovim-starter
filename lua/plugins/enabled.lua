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
    config = true,
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
      { "junegunn/fzf" },
      { "junegunn/fzf.vim" }, -- to enable preview (optional)
    },
    main = "lspfuzzy",
  },

  {
    "akinsho/toggleterm.nvim",
    version = "*",
    event = "VeryLazy",
    keys = {
      { "<leader>t", "<cmd>ToggleTerm cmd='exec bash -l'<cr>", desc = "Toggle Term" },
    },
    config = true,
  },

  {
    "ray-x/go.nvim",
    dependencies = { -- optional packages
      "ray-x/guihua.lua",
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    cond = function()
      return vim.fn.executable("go") == 1
    end,
    config = function(_, opts)
      require("go").setup(opts)
    end,
    event = { "CmdlineEnter" },
    ft = { "go", 'gomod' },
    build = function()
      if vim.fn.executable("go") == 1 then
        require("go.install").update_all_sync()
      end
    end -- if you need to install/update all binaries
  },

  {
    'akinsho/flutter-tools.nvim',
    cond = function()
      return vim.fn.executable("flutter") == 1
    end,
    event = "VeryLazy",
    dependencies = {
      'nvim-lua/plenary.nvim',
      'stevearc/dressing.nvim', -- optional for vim.ui.select
    },
    config = true,
  },

  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.autoformat = true
      local servers = opts.servers
      local remove_lsps = function(...)
        local lsps = { ... }
        for i = 1, #lsps do
          local k = lsps[i]
          local server = servers[k]
          if server ~= nil then
            server.enabled = false
          end
        end
      end
      if vim.fn.executable("java") == 0 then
        remove_lsps("jdtls")
      end
      if vim.fn.executable("npm") == 0 then
        remove_lsps("pyright", "dockerls", "docker_compose_language_service", "jsonls")
      end
      if vim.fn.executable("python3") == 0 then
        remove_lsps("pyright", "ruff_lsp")
      end
      if vim.fn.executable("go") == 0 then
        remove_lsps("gopls")
      end
      return opts
    end
  },
}

return config

-- vim600: foldmethod=marker sw=2 ts=2
