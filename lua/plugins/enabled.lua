-- since this is just an example spec, don"t actually load anything here and return an empty spec
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
        "folke/tokyonight.nvim", -- "folke/tokyonight.nvim"
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
        config = function(_, opts)
            vim.g.loaded_netrw = 1
            vim.g.loaded_netrwPlugin = 1

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

            require("neo-tree").setup(opts)
            vim.api.nvim_create_autocmd("TermClose", {
                pattern = "*lazygit",
                callback = function()
                    if package.loaded["neo-tree.sources.git_status"] then
                        require("neo-tree.sources.git_status").refresh()
                    end
                end,
            })
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
        config = function(_, opts)
            vim.g.CloseWindow = function(idx)
                local cmd
                if idx == 1 then
                    cmd = "q"
                else
                    cmd = "x"
                end

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
                require("mini.bufremove").delete(0)
                local win_cnt = vim.fn.winnr("$")
                if win_cnt > 1 then
                    vim.cmd(cmd)
                end
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
        config = true,
    },

    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function ()
            if vim.fn.has("win32") == 1 then
                require "nvim-treesitter.install".compilers = { "clang" }
            end

            require("nvim-treesitter.configs").setup{
                highlight = { enable = true },
                indent = { enable = true },
                auto_install = true,
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
            }
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
        config = true,
    },

    {
        "nvim-telescope/telescope.nvim",
        config = function (_, opts)
            opts.defaults.history = false
            require("telescope").setup(opts)
        end
    },

    {
        "ojroques/nvim-lspfuzzy",
        requires = {
            {"junegunn/fzf"},
            {"junegunn/fzf.vim"},  -- to enable preview (optional)
        },
        config = function (_, opts)
            require("lspfuzzy").setup(opts)
        end
    },

    {
        "akinsho/toggleterm.nvim",
        version = "*",
        event = "VeryLazy",
        keys = {
            { "<leader>t", "<cmd>ToggleTerm cmd='exec bash -l'<cr>", desc="Toggle Term" },
        },
        config = true
    },
}

-- vim600: foldmethod=marker
