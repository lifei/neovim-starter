    -- Disabled plugin
    -- {{{
    {
        'navarasu/onedark.nvim', -- 'folke/tokyonight.nvim'
        lazy = true, -- make sure we load this during startup if it is your main colorscheme
        priority = 1000, -- make sure to load this before all the other start plugins
        enable = false,
        config = function()
            -- 使用 warmer 风格
            local onedark_theme = require('onedark')
            onedark_theme.setup({ style = 'warmer' })
            onedark_theme.load()

            -- 整点儿斜体，能更好看点
            vim.cmd.highlight({ 'StatusLine', 'cterm=italic', 'gui=italic' })
            vim.cmd.highlight({ 'String',     'cterm=italic', 'gui=italic' })
            vim.cmd.highlight({ 'Comment',    'cterm=italic', 'gui=italic' })
            vim.cmd.highlight({ 'Todo',       'cterm=italic', 'gui=italic' })
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
			},
			filesystem = {
				bind_to_cwd = false,
				use_libuv_file_watcher = true,
				follow_current_file = {
					enabled = true, -- This will find and focus the file in the active buffer every time
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
				local manager = require("neo-tree.sources.manager")
				local reveal_file = manager.get_path_to_reveal()
				print(reveal_file)

				require("neo-tree.command").execute({
                    open = true,
                    dir = vim.loop.cwd(),
					reveal_file = reveal_file,
					reveal_force_cwd = true,
				})
            end, { desc = 'Toggle Active Window', noremap = true })

            vim.keymap.set('n', '<leader>f', ':NvimTreeFindFile<CR>', { noremap = true })
            vim.keymap.set('n', '<S-tab>', ':b#<CR>', { noremap = true })
            vim.keymap.set('n', '<C-Tab>', ':bn<CR>', { noremap = true })
            vim.keymap.set('n', '<leader>d', function()
                if string.match(vim.fn.bufname(), 'NvimTree_%d+') then
                    vim.cmd('wincmd l')
                end
                if string.match(vim.fn.bufname(), 'NvimTree_%d+') then
                    return
                end
                vim.cmd('bufdo Bdelete')
            end, { noremap = true })
            vim.g.IsLastWindow = function()
                local win_cnt = vim.fn.winnr('$')
                -- 超过两个以上的窗口，随便关
                if win_cnt > 2 then
                    return false
                end

                -- 目录窗口，随便关
                if string.match(vim.fn.bufname(), 'NvimTree_%d+') then
                    return false
                end

                local bufs = vim.fn.getbufinfo({ buflisted = 1 })
                local buf_cnt = #bufs
                if buf_cnt == 1 then
                    return false
                end

                if win_cnt == 1 then
                    return buf_cnt > 1
                end
                
                -- 另一个窗口不是目录树
                local next_win_nr = 3 - vim.fn.winnr()
                return string.match(vim.fn.bufname(vim.fn.winbufnr(next_win_nr)), 'NvimTree_%d+') and buf_cnt > 1
            end

            vim.cmd("cnoreabbrev <expr> q getcmdtype() == ':' && getcmdline() == 'q' && g:IsLastWindow() ? 'Bdelete' : 'q'")
            vim.cmd("cnoreabbrev <expr> x getcmdtype() == ':' && getcmdline() == 'x' && g:IsLastWindow() ? 'w<CR>:Bdelete<CR>' : 'x'")
        end

    },


    --
    -- }}}


-- =====================================
-- Plugins
-- =====================================
-- {{{

if false then
require('lazy').setup({
    {
        'moll/vim-bbye',
        event = 'VeryLazy'
    },
    -- the colorscheme should be available when starting Neovim
    {
        'folke/tokyonight.nvim', -- 'folke/tokyonight.nvim'
        lazy = false, -- make sure we load this during startup if it is your main colorscheme
        priority = 1000, -- make sure to load this before all the other start plugins
        enable = true,
        config = function()
            -- load the colorscheme here
            vim.cmd([[colorscheme tokyonight]])
        end,
    },
    {
        'navarasu/onedark.nvim', -- 'folke/tokyonight.nvim'
        lazy = true, -- make sure we load this during startup if it is your main colorscheme
        priority = 1000, -- make sure to load this before all the other start plugins
        config = function()
            -- 使用 warmer 风格
            local onedark_theme = require('onedark')
            onedark_theme.setup({ style = 'warmer' })
            onedark_theme.load()

            -- 整点儿斜体，能更好看点
            vim.cmd.highlight({ 'StatusLine', 'cterm=italic', 'gui=italic' })
            vim.cmd.highlight({ 'String',     'cterm=italic', 'gui=italic' })
            vim.cmd.highlight({ 'Comment',    'cterm=italic', 'gui=italic' })
            vim.cmd.highlight({ 'Todo',       'cterm=italic', 'gui=italic' })
        end,
    },

    -- NvimTree
    -- {{{
    {
        'nvim-tree/nvim-tree.lua',
        config = function()

            vim.g.loaded_netrw = 1
            vim.g.loaded_netrwPlugin = 1

            vim.keymap.set('n', '<leader>mn', require('nvim-tree.api').marks.navigate.next)
            vim.keymap.set('n', '<leader>mp', require('nvim-tree.api').marks.navigate.prev)
            vim.keymap.set('n', '<leader>ms', require('nvim-tree.api').marks.navigate.select)

            vim.keymap.set('n', '<leader><leader>', function()
                if string.match(vim.fn.bufname(), 'NvimTree_%d+') then
                    vim.cmd('wincmd l')
                    return
                end
                vim.cmd('NvimTreeFocus')
            end, { noremap = true })

            vim.keymap.set('n', '<leader>f', ':NvimTreeFindFile<CR>', { noremap = true })
            vim.keymap.set('n', 'qq', ':Bdelete<CR>', { noremap = true })
            vim.keymap.set('n', '<S-tab>', ':b#<CR>', { noremap = true })
            vim.keymap.set('n', '<C-Tab>', ':bn<CR>', { noremap = true })
            vim.keymap.set('n', '<leader>d', function()
                if string.match(vim.fn.bufname(), 'NvimTree_%d+') then
                    vim.cmd('wincmd l')
                end
                if string.match(vim.fn.bufname(), 'NvimTree_%d+') then
                    return
                end
                vim.cmd('bufdo Bdelete')
            end, { noremap = true })
            vim.g.IsLastWindow = function()
                local win_cnt = vim.fn.winnr('$')
                -- 超过两个以上的窗口，随便关
                if win_cnt > 2 then
                    return false
                end

                -- 目录窗口，随便关
                if string.match(vim.fn.bufname(), 'NvimTree_%d+') then
                    return false
                end

                local bufs = vim.fn.getbufinfo({ buflisted = 1 })
                local buf_cnt = #bufs
                if buf_cnt == 1 then
                    return false
                end

                if win_cnt == 1 then
                    return buf_cnt > 1
                end
                
                -- 另一个窗口不是目录树
                local next_win_nr = 3 - vim.fn.winnr()
                return string.match(vim.fn.bufname(vim.fn.winbufnr(next_win_nr)), 'NvimTree_%d+') and buf_cnt > 1
            end

            vim.cmd("cnoreabbrev <expr> q getcmdtype() == ':' && getcmdline() == 'q' && g:IsLastWindow() ? 'Bdelete' : 'q'")
            vim.cmd("cnoreabbrev <expr> x getcmdtype() == ':' && getcmdline() == 'x' && g:IsLastWindow() ? 'w<CR>:Bdelete<CR>' : 'x'")

            require('nvim-tree').setup({
                git = {
                    enable = false,
                },
                view = {
                    width = 30,
                },
                renderer = {
                    group_empty = true,
                },
                filters = {
                    dotfiles = true,
                },
                renderer = {
                    indent_width = 3,
                    indent_markers = {
                        enable = false,
                    },
                    group_empty = true,
                    icons = {
                        webdev_colors = true,
                        git_placement = 'after',
                        modified_placement = 'after',
                        padding = ' ',
                        symlink_arrow = '→',
                        show = {
                            file = true,
                            folder = true,
                            folder_arrow = true,
                            git = true,
                            modified = true,
                        },
                        glyphs = {
                            default = '📄',
                            symlink = '📏',
                            bookmark = '📍',
                            modified = '●',
                            folder = {
                                arrow_closed = '▶',
                                arrow_open = '▼',
                                default = '📁',
                                open = '📂',
                                empty = '📁',
                                empty_open = '📂',
                                symlink = '📁',
                                symlink_open = '📂',
                            },
                            git = {
                                unstaged = '✗',
                                staged = '✓',
                                unmerged = '',
                                renamed = '➜',
                                untracked = '★',
                                deleted = '‼️',
                                ignored = '◌',
                            },
                        },
                    },
                }
            })

            -- NvimTree Auto Close
            -- https://github.com/nvim-tree/nvim-tree.lua/wiki/Auto-Close
            vim.api.nvim_create_autocmd('QuitPre', {
              callback = function()
                local current_bufname = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(0))
                if current_bufname:match('NvimTree_') ~= nil then
                  return
                end

                local invalid_win = 0
                local wins = vim.api.nvim_list_wins()
                for _, w in ipairs(wins) do
                  local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(w))
                  if bufname:match('NvimTree_') ~= nil then
                    invalid_win = invalid_win + 1
                  end
                end
                if invalid_win == #wins - 1 then
                  vim.cmd('NvimTreeClose')
                end
              end
            })


        end
    },

    -- }}}

    -- 'akinsho/bufferline.nvim', { 'tag': '*' }
    -- 'chr4/nginx.vim'
    -- 'ekalinin/Dockerfile.vim'
    -- 'skanehira/docker-compose.vim'
    -- 'fatih/vim-go'
    -- 'mustache/vim-mustache-handlebars'
    -- 'williamboman/mason.nvim'
    -- 'williamboman/mason-lspconfig.nvim'
    -- 'neovim/nvim-lspconfig'

    -- hrsh7th/nvim-cmp
    -- {{{
    {
        'hrsh7th/nvim-cmp',
        version = false, -- last release is way too old
        event = 'InsertEnter',
        dependencies = {
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-path',
            'saadparwaiz1/cmp_luasnip',
        },
        opts = function()
            vim.api.nvim_set_hl(0, 'CmpGhostText', { link = 'Comment', default = true })
            local cmp = require('cmp')
            local defaults = require('cmp.config.default')()
            return {
                completion = {
                    completeopt = 'menu,menuone,noinsert',
                },
                snippet = {
                    expand = function(args)
                        require('luasnip').lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ['<C-n>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
                    ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
                    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-f>'] = cmp.mapping.scroll_docs(4),
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<C-e>'] = cmp.mapping.abort(),
                    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
                    ['<S-CR>'] = cmp.mapping.confirm({
                        behavior = cmp.ConfirmBehavior.Replace,
                        select = true,
                    }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
                    ['<C-CR>'] = function(fallback)
                        cmp.abort()
                        fallback()
                    end,
                }),
                sources = cmp.config.sources({
                    { name = 'nvim_lsp' },
                    { name = 'luasnip' },
                    { name = 'path' },
                }, {
                    { name = 'buffer' },
                }),
                experimental = {
                    ghost_text = {
                        hl_group = 'CmpGhostText',
                    },
                },
                sorting = defaults.sorting,
            }
        end,
        ---@param opts cmp.ConfigSchema
        config = function(_, opts)
            for _, source in ipairs(opts.sources) do
                source.group_index = source.group_index or 1
            end
            require('cmp').setup(opts)
        end,
    },
    -- }}}

    -- LSP
    -- {{{
    {
        'williamboman/mason.nvim',
        config = function()
            require('mason').setup()
        end
    },
    {
        'williamboman/mason-lspconfig.nvim',
        dependencies = {
            'williamboman/mason.nvim',
        },
        config = function()
            require('mason-lspconfig').setup {
                ensure_installed = { 'pyright' },
            }
        end
    },
    {
        'neovim/nvim-lspconfig',
        event = 'VeryLazy',
        dependencies = {
            'williamboman/mason-lspconfig.nvim',
        },
        ---@class PluginLspOpts
        opts = {
            -- options for vim.diagnostic.config()
            diagnostics = {
                underline = true,
                update_in_insert = false,
                virtual_text = {
                    spacing = 4,
                    source = 'if_many',
                    prefix = '●',
                    -- this will set set the prefix to a function that returns the diagnostics icon based on the severity
                    -- this only works on a recent 0.10.0 build. Will be set to '●' when not supported
                    -- prefix = 'icons',
                },
                severity_sort = true,
            },
            -- Enable this to enable the builtin LSP inlay hints on Neovim >= 0.10.0
            -- Be aware that you also will need to properly configure your LSP server to
            -- provide the inlay hints.
            inlay_hints = {
                enabled = false,
            },
            -- add any global capabilities here
            capabilities = {},
            -- options for vim.lsp.buf.format
            -- `bufnr` and `filter` is handled by the LazyVim formatter,
            -- but can be also overridden when specified
            format = {
                formatting_options = nil,
                timeout_ms = nil,
            },
            -- LSP Server Settings
            ---@type lspconfig.options
            servers = {
                lua_ls = {
                    -- mason = false, -- set to false if you don't want this server to be installed with mason
                    -- Use this to add any additional keymaps
                    -- for specific lsp servers
                    ---@type LazyKeysSpec[]
                    -- keys = {},
                    settings = {
                        Lua = {
                            workspace = {
                                checkThirdParty = false,
                            },
                            completion = {
                                callSnippet = 'Replace',
                            },
                        },
                    },
                },
            },
            -- you can do any additional lsp server setup here
            -- return true if you don't want this server to be setup with lspconfig
            ---@type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
            setup = {
                -- example to setup with typescript.nvim
                -- tsserver = function(_, opts)
                --   require('typescript').setup({ server = opts })
                --   return true
                -- end,
                -- Specify * to use this function as a fallback for any server
                -- ['*'] = function(server, opts) end,
            },
        },
        ---@param opts PluginLspOpts
        config = function(_, opts)
            require('lspconfig').pyright.setup{}

            -- See `:help vim.diagnostic.*` for documentation on any of the below functions
            vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
            vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
            vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
            vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

            -- Use LspAttach autocommand to only map the following keys
            -- after the language server attaches to the current buffer
            vim.api.nvim_create_autocmd('LspAttach', {
              group = vim.api.nvim_create_augroup('UserLspConfig', {}),
              callback = function(ev)
                -- Enable completion triggered by <c-x><c-o>
                vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

                -- Buffer local mappings.
                -- See `:help vim.lsp.*` for documentation on any of the below functions
                local opts = { buffer = ev.buf }
                vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
                vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
                vim.keymap.set('n', '<C-]>', vim.lsp.buf.definition, opts)
                vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
                vim.keymap.set('i', '<C-_>', '<C-x><C-o>', opts)
                vim.keymap.set('n', '<C-i>', vim.lsp.buf.implementation, opts)
                vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
                vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
                vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
                vim.keymap.set('n', '<space>wl', function()
                  print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                end, opts)
                vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
                vim.keymap.set('n', '<A-R>', vim.lsp.buf.rename, opts)
                vim.keymap.set({ 'n', 'v' }, '<C-1>', vim.lsp.buf.code_action, opts)
                vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
                vim.keymap.set('n', '<C-A-G>', vim.lsp.buf.references, opts)
                vim.keymap.set('n', '<A-F>', function()
                  vim.lsp.buf.format { async = true }
                end, opts)
              end,
            })
        end,
    },
    -- }}}

    {
        'akinsho/bufferline.nvim',
        event = 'VeryLazy',
        config = function()
            require('bufferline').setup{
                options = {
                    close_command = 'Bdelete! %d',
                    right_mouse_command = 'Bdelete! %d',
                    indicator = {
                        icon = '🚩', -- this should be omitted if indicator style is not 'icon'
                        style = 'icon',
                    },
                    -- name_formatter = function(buf)
                    --     return buf.bufnr .. '·' .. buf.name
                    -- end,
                    show_duplicate_prefix = true, -- whether to show duplicate buffer prefix
                    -- 使用 nvim 内置lsp
                    diagnostics = 'nvim_lsp',
                    buffer_close_icon = '×',
                    modified_icon = '⚫',
                    close_icon = '×',
                    left_trunc_marker = '👈',
                    right_trunc_marker = '👉',
                    color_icons = true,
                    show_buffer_icons = true,
                    show_tab_indicators = true,
                    separator_style = { '\\|', '|' },
                    always_show_bufferline = false,
                    numbers = function(opts)
                        return string.format('%s', opts.raise(opts.id))
                    end,
                    sort_by = 'id',
                    -- 左侧让出 nvim-tree 的位置
                    offsets = {{
                        filetype = 'NvimTree',
                        text = 'File Explorer',
                        highlight = 'Directory',
                        text_align = 'left'
                    }}
                }
            }
        end
    },

    { 'folke/which-key.nvim', lazy = true },
    { 'folke/noice.nvim', lazy = true },
})
end
-- }}}
