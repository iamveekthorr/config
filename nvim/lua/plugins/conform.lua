return {
  "stevearc/conform.nvim",
  optional = true,
  opts = function(_, opts)
    local sql_ft = { "sql", "mysql", "plsql" }

    opts.formatters_by_ft = opts.formatters_by_ft or {}
    opts.formatters = opts.formatters or {}

    -- Configure sqruff formatter with custom settings
    opts.formatters.sqruff = {
      command = "sqruff",
      args = function(_, ctx)
        local configs = vim.fs.find(".sqruff", { upward = true, path = ctx.dirname })
        local config_file = configs[#configs] -- pick the last (closest to project root)
        if config_file then
          return { "fix", "--config", config_file, "-" }
        else
          return { "fix", "-" }
        end
      end,
      stdin = true,
    }

    -- Override any existing SQL formatters
    opts.formatters_by_ft.nginx = { "nginxfmt" }
    opts.formatters_by_ft.nix = { "nixfmt" }
    opts.formatters_by_ft.toml = { "pyproject-fmt" }
    opts.formatters_by_ft.css = { "prettier" }
    opts.formatters_by_ft.scss = { "prettier" }
    opts.formatters_by_ft.rust = { "rustfmt" }
    opts.formatters_by_ft.go = { "gofmt" }

    -- Add sqruff to all SQL file types
    for _, ft in ipairs(sql_ft) do
      opts.formatters_by_ft[ft] = { "sqruff" }
    end
  end,
}
