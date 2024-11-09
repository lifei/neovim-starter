local config = {
  "nvim-telescope/telescope.nvim",
  opts = {
    defaults = {
      preview = {
        filesize_limit = 1, -- MB
      },
    },
  },
}

if vim.fn.executable("rg") == 1 then
  config.opts.defaults.vimgrep_arguments = {
    "rg",
    "--color=never",
    "--no-heading",
    "--with-filename",
    "--line-number",
    "--column",
    "--smart-case",
    "--trim", -- add this value
  }
end

if vim.fn.executable("fd") == 1 then
  config.opts.pickers = {
    find_files = {
      find_command = { "fd", "--type", "f", "--strip-cwd-prefix" },
    },
  }
end

local fzf_native_config = {
  "nvim-telescope/telescope-fzf-native.nvim",
  cond = function()
    return vim.fn.executable("make") == 1 and vim.fn.executable("gcc") == 1
  end,
}
if vim.fn.has("win32") == 1 then
  local env = vim.fn.environ()
  local msystem = env["MSYSTEM"]
  if msystem ~= nil then
    fzf_native_config.build = "MSYSTEM=MSYS64 make"
  end
end

return { config, fzf_native_config }
