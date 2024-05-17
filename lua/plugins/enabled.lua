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
    "nvim-neo-tree/neo-tree.nvim",
    version = "3.5",
    keys = {
      { "\\\\", function()
        if vim.bo.filetype == "neo-tree" then
          vim.cmd("wincmd l")
          return
        end
        require("neo-tree.command").execute({
          open = true,
          source = "filesystem",
          dir = vim.loop.cwd(),
        })
      end, desc = "Toggle Active Window", noremap = true },
    },
    opts = function (_, opts)
      local function on_move(data)
        Util.lsp.on_rename(data.source, data.destination)
      end

      local events = require("neo-tree.events")
      opts.event_handlers = opts.event_handlers or {}
      vim.list_extend(opts.event_handlers, {
        { event = events.FILE_MOVED, handler = on_move },
        { event = events.FILE_RENAMED, handler = on_move },
      })

      opts.close_if_last_window = true
      opts.window = {
        width = 25,
        mappings = {
          ["<space>"] = "none",
          ["Y"] = function(state)
            local node = state.tree:get_node()
            local path = node:get_id()
            vim.fn.setreg("+", path, "c")
          end,
        },
      }
      opts.default_component_configs.git_status = {
        symbols = {
          -- Change type
          added     = "✚", -- or "✚", but this is redundant info if you use git_status_colors on the name
          modified  = "", -- or "", but this is redundant info if you use git_status_colors on the name
          deleted   = "✖",-- this can only be used in the git_status source
          renamed   = "󰁕",-- this can only be used in the git_status source
          -- Status type
          untracked = "",
          ignored   = "",
          unstaged  = "󰄱",
          staged    = "",
          conflict  = "",
        }
      }

      opts.filesystem.follow_current_file.leave_dirs_open = true
      opts.buffers = { follow_current_file = { enabled = true } }
      opts. document_symbols = {
        follow_cursor = true,
        renderers = {
          root = {
            { "icon", default = "C" },
            { "name", zindex = 10 },
          },
          symbol = {
            { "indent",    with_expanders = true },
            { "kind_icon", default = "?" },
            {
              "container",
              content = {
                { "name", zindex = 10 },
              }
            }
          },
        },
        window = {
          mappings = {
            ["<cr>"] = "jump_to_symbol",
            ["<2-LeftMouse>"] = "jump_to_symbol",
          }
        }
      }
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1
      require("neo-tree").setup(opts)
      vim.api.nvim_create_autocmd("TermClose", {
        pattern = "*lazygit",
        callback = function()
          if package.loaded["neo-tree.sources.git_status"] then
            require("neo-tree.sources.git_status").refresh()
          end
        end,
      })
      return opts
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
    "echasnovski/mini.bufremove",
    event = "VeryLazy",
    config = function(_, opts)
      vim.g.CloseWindow = function(idx)
        local cmd = idx == 1 and "q" or "x"

        -- 目录窗口，随便关
        if vim.bo.filetype == "neo-tree" then
          vim.cmd("q")
          return
        end

        -- 只剩下一个buf
        local bufs = vim.fn.getbufinfo({ buflisted = 1 })
        local buf_cnt = #bufs
        if buf_cnt == 1 then
          vim.cmd(cmd)
          return
        end

        if not vim.bo.buflisted then
          vim.cmd(cmd)
          return
        end

        local next_buf_id = vim.fn.winbufnr(vim.fn.winnr('#'))
        for _, buf in ipairs(bufs) do
          if buf.bufnr == next_buf_id then
            vim.cmd(cmd)
          end
        end
        require("mini.bufremove").delete(0)
      end

      vim.cmd("cnoreabbrev <expr> q getcmdtype() == ':' && getcmdline() == 'q' ? 'call g:CloseWindow(1)<CR>' : 'q'")
      vim.cmd("cnoreabbrev <expr> x getcmdtype() == ':' && getcmdline() == 'x' ? 'call g:CloseWindow(2)<CR>' : 'x'")

      require("mini.bufremove").setup(opts)
    end,
  },

  {
    "bufferline.nvim",
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
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    opts = {
      highlight = { enable = true },
      indent = { enable = true },
      auto_install = true,
      ensure_installed = {
        "bash",
        "html",
        "javascript",
        "json",
        "lua",
        "markdown",
        "python",
        "toml",
        "typescript",
        "vim",
        "vimdoc",
        "yaml",
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },
      textobjects = {
        move = {
          enable = true,
          goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer" },
          goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer" },
          goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer" },
          goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer" },
        },
      },
    },
    config = function (_, opts)
      if vim.fn.has("win32") == 1 then
        require 'nvim-treesitter.install'.prefer_git = false
        require 'nvim-treesitter.install'.compilers = { "zig", "gcc", "g++", "clang", "cl" }
      end

      require("nvim-treesitter.configs").setup(opts)
    end
  },

  {
    "nvim-telescope/telescope.nvim",
    opts = function (_, opts)
      opts.defaults.history = false
      return opts
    end,
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
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        ["sql"] = { { "sql_formatter", "sqlfmt" } },
      },
      formatters = {
        sql_formatter = {
          prepend_args = { "-l", "sqlite", "-c", '{"tabWidth": 4, "keywordCase": "upper", "linesBetweenQueries": 2}', }
        },
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      -- make sure mason installs the server
      servers = {
        jdtls = {}
      },
      setup = {
        jdtls = function()
          return true -- avoid duplicate servers
        end,
      },
    },
  },
  {
    "mfussenegger/nvim-jdtls",
    opts = {
      settings = {
        java = {
          format = {enabled = true },
          gradle = { enabled = true },
          jdt = { ls = { androidSupport = { enabled = true }}},
          configuration = {
            runtimes = {
              {
                name = "JavaSE-11",
                path = "./.sdkman/candidates/java/11.0.10-open/",
              },
              {
                name = "JavaSE-14",
                path = "./.sdkman/candidates/java/14.0.2-open/",
              },
              {
                name = "JavaSE-15",
                path = "./.sdkman/candidates/java/15.0.1-open/",
              },
            }
          }
        }
      },
    }
  }
}

if vim.fn.has("win32") == 1 then
  if vim.fn.executable("make") ~= 1 then
    table.insert(config, { "nvim-telescope/telescope-fzf-native.nvim", enabled = false })
  else
    local env = vim.fn.environ()
    local msystem = env["MSYSTEM"]
    if msystem ~= nil then
      table.insert(config, {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "MSYSTEM=MSYS64 make",
      })
    end
  end
end

return config

-- vim600: foldmethod=marker
