return {
  "echasnovski/mini.bufremove",
  event = "VeryLazy",
  init = function()
    vim.g.CloseWindow = function(idx)
      local cmd = idx == 1 and "q" or "x"

      -- 目录窗口，随便关
      if vim.bo.filetype == "neo-tree" then
        vim.cmd("q")
        return
      end

      if not vim.bo.buflisted then
        vim.cmd(cmd)
        return
      end

      -- 只剩下一个buf
      local bufs = vim.fn.getbufinfo({ buflisted = 1 })
      local buf_cnt = #bufs
      if buf_cnt == 1 then
        vim.cmd(cmd)
        return
      end

      local curwinid = vim.fn.winnr()
      local wins = vim.fn.getwininfo()
      for _, win in ipairs(wins) do
        if win.winnr ~= curwinid then
          if vim.bo[win.bufnr].buflisted then
            vim.cmd(cmd)
            return
          end
        end
      end
      require("mini.bufremove").delete(0)
    end

    vim.cmd("cnoreabbrev <expr> q getcmdtype() == ':' && getcmdline() == 'q' ? 'call g:CloseWindow(1)<CR>' : 'q'")
    vim.cmd("cnoreabbrev <expr> x getcmdtype() == ':' && getcmdline() == 'x' ? 'call g:CloseWindow(2)<CR>' : 'x'")
  end,
}
