return {
  "mfussenegger/nvim-jdtls",
  ft = "java",
  opts = {
    jdtls = {
      settings = {
        java = {
          home = "C:\\Program Files\\Java\\jdk-20",
          jdtls = {
            ls = {
              androidSupport = {
                enabled = true,
              },
            },
          },
          configuration = {
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
          },
        },
      },
    },
  },
}
