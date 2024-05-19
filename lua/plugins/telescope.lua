local config = {
  "nvim-telescope/telescope.nvim",
  opts = {
    defaults = {
      preview = {
        filesize_limit = 1, -- MB
      },
      vimgrep_arguments = {
        "rg",
        "--color=never",
        "--no-heading",
        "--with-filename",
        "--line-number",
        "--column",
        "--smart-case",
        "--trim", -- add this value
      },
    },
    pickers = {
      find_files = {
        find_command = { "fd", "--type", "f", "--strip-cwd-prefix" },
      },
    },
  },
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
