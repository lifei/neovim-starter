return {
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

      local next_buf_id = vim.fn.winbufnr(vim.fn.winnr("#"))
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
}
