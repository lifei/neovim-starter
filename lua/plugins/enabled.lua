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
    lazy = true,
    keys = {
      { "<leader>tt", "<cmd>ToggleTerm<cr>", desc = "Toggle Terminal" },
      { "<leader>tb", "<cmd>ToggleTerm direction=tab<cr>", desc = "Toggle Termimal(Tab)" },
      { "<leader>tf", "<cmd>ToggleTerm direction=float<cr>", desc = "Toggle Termimal(Float)" },
      { "<leader>th", "<cmd>ToggleTerm direction=horizontal<cr>", desc = "Toggle Termimal(Horizontal)" },
      { "<leader>tv", "<cmd>ToggleTerm direction=vertical size=" .. (vim.o.columns / 3) .. "<cr>", desc = "Toggle Termimal(Vertical)" },
      { "<leader>tp", "<cmd>TermExec cmd=pwsh.exe<cr>", desc = "Toggle Powershell" },
    },
    config = true,
		opts = function(_, opts)
      if vim.fn.has("win32") == 1 then
			  opts.shell = 'exec /usr/bin/bash -i -l'
        -- opts.on_open = function() end
      elseif vim.fn.has("linux") == 1 then
			  opts.shell = 'exec /usr/bin/bash -i -l'
      end
      opts.float_opts = { border = 'double', title_pos = 'center' }
      return opts
    end,
    main = "toggleterm",
  },

  {
    "ray-x/go.nvim",
    lazy = true,
    dependencies = { -- optional packages
      "ray-x/guihua.lua",
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    cond = function()
      return vim.fn.executable("go") == 1
    end,
    build = function()
      if vim.fn.executable("go") == 1 then
        require("go.install").update_all_sync()
      end
    end -- if you need to install/update all binaries
  },

  {
    'akinsho/flutter-tools.nvim',
    lazy = true,
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
        remove_lsps("basedpyright", "ruff", "pyright", "ruff_lsp")
      end
      if vim.fn.executable("go") == 0 then
        remove_lsps("gopls")
      end
      if vim.loop.os_getenv("TERMUX_VERSION") ~= nil then
        remove_lsps("lua_ls", "stylua")
      end
      return opts
    end
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts_extend = { "spec" },
    opts = {
      spec = {
        { "<leader>t", group = "terminal", icon = { icon = " ", color = "cyan" } },
        { "<leader>r", group = "surround", icon = { icon = "ⓢ ", color = "cyan" }, mode = { "v" } },
      }
    },
  },
}

return config

-- vim600: foldmethod=marker sw=2 ts=2
