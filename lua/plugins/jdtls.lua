local config = {
  "mfussenegger/nvim-jdtls",
  cond = function()
    return vim.fn.executable("java") == 1
  end,
  dependencies = { "williamboman/mason.nvim" },
  ft = "java",
  opts = function(_, opts)
    local install_path = require("mason-registry").get_package("jdtls"):get_install_path()
    opts = require("lazy.util").merge(
      opts,
      -- code
      {
        jdtls = {
          cmd = {
            install_path .. "/jdtls",
            "--jvm-arg=-javaagent:" .. install_path .. "/lombok.jar",
          },
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
      }
    )

    if vim.fn.has("win32") == 1 then
      opts.jdtls.settings.java.home = "C:\\Program Files\\Java\\jdk-20"
      opts.jdtls.settings.java.configuration = {
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
      opts.jdtls.settings.java.home = "/Users/lifei/Library/Java/JavaVirtualMachines/openjdk-22.0.1/Contents/Home"
      opts.jdtls.settings.java.configuration = {
        runtimes = {
          {
            name = "JavaSE-22",
            path = "/Users/lifei/Library/Java/JavaVirtualMachines/openjdk-22.0.1/Contents/Home",
            default = true,
          },
        },
      }
    end
    return opts
  end,
}

return config
