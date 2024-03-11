-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- =====================================
-- Colors、Cursor、Theme
-- =====================================
-- {{{

if vim.fn.has('termguicolors') then
    vim.opt.termguicolors = true
end
vim.cmd.highlight({ 'CursorLine', 'cterm=NONE', 'ctermbg=darkblue', 'ctermfg=NONE', 'guibg=darkblue' })
vim.opt.cursorline = true
-- vim.opt.t_Co = 256
vim.opt.guicursor = 'n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,sm:block-blinkwait175-blinkoff150-blinkon175'
vim.opt.guifont = "DaddyTimeMono Nerd Font Mono:h16"
-- "Sarasa Term SC Nerd:h12", "等距更纱黑体 SC:h14"

vim.api.nvim_create_autocmd({'ExitPre'}, {
    callback = function()
        vim.cmd('set guicursor=n-v-c:ver25')
    end,
})

-- }}}


-- =====================================
-- Settings
-- =====================================
-- {{{
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.number = true

vim.keymap.set('n', ';', ':', { noremap = true })
vim.keymap.set('n', '!', ':!', { noremap = true })

-- au BufNewFile,BufRead *.conf set filetype=nginx
-- au BufNewFile,BufRead *.7v1.net* set filetype=nginx

vim.g.loaded_python3_provider = 0
vim.g.loaded_zip = 0
vim.g.loaded_zipPlugin= 0
-- }}}

-- =====================================
-- Windows
-- =====================================
-- {{{
if vim.fn.has('win32') == 1 then
    vim.opt.shell = 'bash.exe'
    vim.opt.shellxquote = '('
    vim.opt.shellslash = true
    vim.opt.shellcmdflag = '-c'
    vim.opt.shellredir = '>%s 2>&1'
    vim.opt.shellpipe = '2>&1| tee'

    vim.g.clipboard = {
        name = 'MSYS2',
        copy = {
            ['+'] = 'tee /dev/clipboard'
        },
        paste = {
            ['+'] = 'cat /dev/clipboard'
        },
        cache_enabled = 1
    }
end
-- }}}


--
--
-- vim600: foldmethod=marker
