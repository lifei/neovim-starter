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

  {
    "ray-x/go.nvim",
    dependencies = {  -- optional packages
      "ray-x/guihua.lua",
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    cond = function()
      return vim.fn.executable("go") == 1
    end,
    config = function()
      require("go").setup()
    end,
    event = {"CmdlineEnter"},
    ft = {"go", 'gomod'},
    build = ':lua require("go.install").update_all_sync()' -- if you need to install/update all binaries
  },

  {
    'akinsho/flutter-tools.nvim',
    cond = function()
      return vim.fn.executable("flutter") == 1
    end,
    dependencies = {
      'nvim-lua/plenary.nvim',
      'stevearc/dressing.nvim', -- optional for vim.ui.select
    },
    config = true,
  },

  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      local servers = opts.servers
      local remove_lsps = function(...)
        local lsps = {...}
        for i=1,#lsps do
          if servers[lsps[i]] ~= nil then
            table.remove(servers, lsps[i])
          end
        end
      end
      if vim.fn.executable("java") == 0 then
          remove_lsps("jdtls")
      end
      if vim.fn.executable("npm") == 0 then
          remove_lsps("pyright", "dockerfile-language-server", "docker-compose-language-service", "json-lsp")
      end
      if vim.fn.executable("python3") == 0 then
        remove_lsps("pyright", "ruff-lsp")
      end
      if vim.fn.executable("go") == 0 then
        remove_lsps("gopls")
      end
      return opts
    end
  }
}

return config

-- vim600: foldmethod=marker sw=2 ts=2
