return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      ["sql"] = { { "sql_formatter", "sqlfmt" } },
      ["javascript"] = { { "prettier", "prettierd" } },
    },
    formatters = {
      sql_formatter = {
        prepend_args = { "-l", "sqlite", "-c", '{"tabWidth": 4, "keywordCase": "upper", "linesBetweenQueries": 2}' },
      },
    },
  },
}
