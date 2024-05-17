-- =====================================
-- Colors、Cursor、Theme
-- =====================================
-- {{{
if vim.fn.has("termguicolors") then
  vim.opt.termguicolors = true
end
vim.cmd.highlight({ "CursorLine", "cterm=NONE", "ctermbg=darkblue", "ctermfg=NONE", "guibg=darkblue" })
vim.opt.cursorline = true
-- vim.opt.t_Co = 256
vim.opt.guicursor =
  "n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,sm:block-blinkwait175-blinkoff150-blinkon175"
vim.opt.guifont = "DaddyTimeMono Nerd Font Mono:h14"
-- "Sarasa Term SC Nerd:h12", "等距更纱黑体 SC:h14"

vim.api.nvim_create_autocmd({ "ExitPre" }, {
  callback = function()
    vim.cmd("set guicursor=n-v-c:ver25")
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

vim.keymap.set("n", ";", ":", { noremap = true })
vim.keymap.set("n", "!", ":!", { noremap = true })

-- au BufNewFile,BufRead *.conf set filetype=nginx
-- au BufNewFile,BufRead *.7v1.net* set filetype=nginx

vim.g.loaded_python3_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_zip = 0
vim.g.loaded_zipPlugin = 0

vim.opt.clipboard = ""
-- }}}

-- =====================================
-- Windows
-- =====================================
-- {{{
if vim.fn.has("win32") == 1 then
  if vim.fn.isdirectory("C:\\Software\\msys64") == 1 then
    vim.fn.setenv("PATH", vim.env.path .. ";C:\\Software\\msys64\\usr\\bin;C:\\Software\\msys64\\ucrt64\\usr\\bin")
    local msystem = vim.fn.environ()["MSYSTEM"]
    if msystem == nil then
      vim.fn.setenv("MSYSTEM", "UCRT64")
    end
  end

  if vim.fn.executable("bash") == 1 and vim.fn.executable("tee") == 1 then
    vim.opt.shell = "bash.exe"
    vim.opt.shellxquote = "("
    vim.opt.shellslash = true
    vim.opt.shellcmdflag = "-c"
    vim.opt.shellredir = ">%s 2>&1"
    vim.opt.shellpipe = "2>&1| tee"
  end
end

if
  vim.g.clipboard == nil
    and vim.fn.executable("cat") == 1
    and vim.fn.executable("tee") == 1
    and (vim.fn.has("win32") == 1 and vim.fn.executable("win32yank") == 0)
  or (vim.fn.has("linux") == 1 and vim.fn.filewritable("/dev/clipboard") == 1)
then
  vim.g.clipboard = {
    name = "cat/tee",
    copy = {
      ["+"] = "tee /dev/clipboard",
    },
    paste = {
      ["+"] = "cat /dev/clipboard",
    },
    cache_enabled = 1,
  }
end
-- }}}

-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
--
--
-- vim600: foldmethod=marker
