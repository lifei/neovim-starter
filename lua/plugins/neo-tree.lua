return {
  "nvim-neo-tree/neo-tree.nvim",
  version = "3.5",
  keys = {
    {
      "\\\\",
      function()
        if vim.bo.filetype == "neo-tree" then
          vim.cmd("wincmd l")
          return
        end
        require("neo-tree.command").execute({
          open = true,
          source = "filesystem",
          dir = vim.loop.cwd(),
        })
      end,
      desc = "Toggle Active Window",
      noremap = true,
    },
  },
  opts = function(_, opts)
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
      width = 40,
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
        added = "✚", -- or "✚", but this is redundant info if you use git_status_colors on the name
        modified = "", -- or "", but this is redundant info if you use git_status_colors on the name
        deleted = "✖", -- this can only be used in the git_status source
        renamed = "󰁕", -- this can only be used in the git_status source
        -- Status type
        untracked = "",
        ignored = "",
        unstaged = "󰄱",
        staged = "",
        conflict = "",
      },
    }

    opts.filesystem.follow_current_file.leave_dirs_open = true
    opts.buffers = { follow_current_file = { enabled = true } }
    opts.document_symbols = {
      follow_cursor = true,
      renderers = {
        root = {
          { "icon", default = "C" },
          { "name", zindex = 10 },
        },
        symbol = {
          { "indent", with_expanders = true },
          { "kind_icon", default = "?" },
          {
            "container",
            content = {
              { "name", zindex = 10 },
            },
          },
        },
      },
      window = {
        mappings = {
          ["<cr>"] = "jump_to_symbol",
          ["<2-LeftMouse>"] = "jump_to_symbol",
        },
      },
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
}
