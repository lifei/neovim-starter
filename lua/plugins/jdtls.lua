if vim.fn.executable("java") == 0 then
  return {
    "mfussenegger/nvim-jdtls",
    enabled = false,
  }
end

local config = {
  "mfussenegger/nvim-jdtls",
  ft = "java",
  opts = {
    jdtls = {
      settings = {
        java = {
          jdtls = {
            ls = {
              androidSupport = {
                enabled = true,
              },
            },
          },
        },
      },
    },
  },
}

if vim.fn.has("win32") == 1 then
  config.opts.jdtls.settings.java.home = "C:\\Program Files\\Java\\jdk-20"
  config.opts.jdtls.settings.java.configuration = {
    runtimes = {
      {
        name = "JavaSE-20",
        path = "C:\\Program Files\\Java\\jdk-20",
        default = true,
      },
      {
        name = "JavaSE-17",
        path = "C:\\Program Files\\Android\\Android Studio\\jbr",
      },
    },
  }
end

if vim.fn.has("mac") == 1 then
  config.opts.jdtls.settings.java.home = "/Users/lifei/Library/Java/JavaVirtualMachines/openjdk-22.0.1/Contents/Home"
  config.opts.jdtls.settings.java.configuration = {
    runtimes = {
      {
        name = "JavaSE-22",
        path = "/Users/lifei/Library/Java/JavaVirtualMachines/openjdk-22.0.1/Contents/Home",
        default = true,
      },
    },
  }
end

return config
