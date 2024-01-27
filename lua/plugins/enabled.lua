-- since this is just an example spec, don't actually load anything here and return an empty spec
-- stylua: ignore
-- if true then return {} end

-- every spec file under the "plugins" directory will be loaded automatically by lazy.nvim
--
-- In your plugin files, you can:
-- * add extra plugins
-- * disable/enabled LazyVim plugins
-- * override the configuration of LazyVim plugins
return {

    -- the colorscheme should be available when starting Neovim
    {
        'folke/tokyonight.nvim', -- 'folke/tokyonight.nvim'
        lazy = false,            -- make sure we load this during startup if it is your main colorscheme
        priority = 1000,         -- make sure to load this before all the other start plugins
        enable = true,
        config = function()
            -- load the colorscheme here
            vim.cmd([[colorscheme tokyonight]])
        end,
    },

    {
        "nvim-neo-tree/neo-tree.nvim",
        version = "3.5",
        enable = false,
        opts = {
            close_if_last_window = true,
            sources = { "filesystem", "buffers", "git_status", "document_symbols" },
            open_files_do_not_replace_types = { "terminal", "Trouble", "trouble", "qf", "Outline" },
            window = {
                mappings = {
                    ["<space>"] = "none",
                },
            },
            default_component_configs = {
                indent = {
                    with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
                    expander_collapsed = "",
                    expander_expanded = "",
                    expander_highlight = "NeoTreeExpander",
                },
                git_status = {
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
                },
            },
            filesystem = {
                bind_to_cwd = false,
                use_libuv_file_watcher = true,
                follow_current_file = {
                    enabled = true,         -- This will find and focus the file in the active buffer every time
                    -- the current file is changed while the tree is open.
                    leave_dirs_open = true, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
                },
            },
            buffers = {
                follow_current_file = { enabled = true }
            },
            document_symbols = {
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
        },
        config = function()
            vim.g.loaded_netrw = 1
            vim.g.loaded_netrwPlugin = 1

            vim.keymap.set('n', '\\\\', function()
                if vim.bo.filetype == 'neo-tree' then
                    vim.cmd('wincmd l')
                    return
                end
                require("neo-tree.command").execute({
                    open = true,
                    source = 'filesystem',
                    dir = vim.loop.cwd(),
                })
            end, { desc = 'Toggle Active Window', noremap = true })
        end

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
        config = function()
            vim.g.CloseWindow = function(idx)

                local cmd
                if idx == 1 then
                    cmd = 'q'
                else
                    cmd = 'x'
                end

                -- 目录窗口，随便关
                if vim.bo.filetype == 'neo-tree' then
                    vim.cmd('q')
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
                require("mini.bufremove").delete(0)
                local win_cnt = vim.fn.winnr('$')
                if win_cnt > 1 then
                    vim.cmd(cmd)
                end
            end

            vim.cmd("cnoreabbrev <expr> q getcmdtype() == ':' && getcmdline() == 'q' ? 'call g:CloseWindow(1)<CR>' : 'q'")
            vim.cmd("cnoreabbrev <expr> x getcmdtype() == ':' && getcmdline() == 'x' ? 'call g:CloseWindow(2)<CR>' : 'x'")
        end,
    },

    {
        'bufferline.nvim',
        opts = {
            options = {
                indicator = {
                    icon = '🚩', -- this should be omitted if indicator style is not 'icon'
                    style = 'icon',
                },
            },
        },
    },

    {
        'nvim-treesitter',
        opts = {
            highlight = { enable = true },
            indent = { enable = true },
            ensure_installed = {
                "bash",
                "c",
                "diff",
                "html",
                "javascript",
                "jsdoc",
                "json",
                "jsonc",
                "lua",
                "luadoc",
                "luap",
                "markdown",
                "markdown_inline",
                "python",
                "query",
                "regex",
                "toml",
                "tsx",
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
        config = function()
            if vim.fn.has('win32') == 1 then
                require 'nvim-treesitter.install'.compilers = { "clang" }
            end
        end
    },

    {
        "simrat39/symbols-outline.nvim",
        keys = { { "<leader>cs", "<cmd>SymbolsOutline<cr>", desc = "Symbols Outline" } },
        cmd = "SymbolsOutline",
        opts = function()
            local Config = require("lazyvim.config")
            local defaults = require("symbols-outline.config").defaults
            local opts = {
                symbols = {},
                symbol_blacklist = {},
            }
            local filter = Config.kind_filter

            if type(filter) == "table" then
                filter = filter.default
                if type(filter) == "table" then
                    for kind, symbol in pairs(defaults.symbols) do
                        opts.symbols[kind] = {
                            icon = Config.icons.kinds[kind] or symbol.icon,
                            hl = symbol.hl,
                        }
                        if not vim.tbl_contains(filter, kind) then
                            table.insert(opts.symbol_blacklist, kind)
                        end
                    end
                end
            end
            return opts
        end,
    },

    {
        "nvim-telescope/telescope.nvim",
        opts = {
            defaults = { history = false },
        }
    },

    {
        "ojroques/nvim-lspfuzzy",
        requires = {
            {'junegunn/fzf'},
            {'junegunn/fzf.vim'},  -- to enable preview (optional)
        },
        config = function ()
            require('lspfuzzy').setup {}
        end
    },

}

-- vim600: foldmethod=marker
