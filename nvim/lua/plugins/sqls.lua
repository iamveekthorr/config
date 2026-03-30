return {
  "nanotee/sqls.nvim",
  ft = { "sql", "mysql" },
  dependencies = { "neovim/nvim-lspconfig" },
  config = function()
    vim.lsp.config("sqls", {
      cmd = { "sqls" },
      filetypes = { "sql", "mysql" },
      root_markers = { ".git" },
      single_file_support = false,
      reuse_client = true,
    })
    vim.lsp.enable("sqls")
  end,
}