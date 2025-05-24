return {
  -- INFO: Updated plugin that replaces the old null-ls
  'nvimtools/none-ls.nvim',
  dependencies = { 'nvim-lua/plenary.nvim' },
  event = 'BufReadPre',
  config = function()
    local null_ls = require("null-ls")

    null_ls.setup({
      sources = {
        null_ls.builtins.formatting.prettier,
        null_ls.builtins.formatting.black,
      },
    })

    -- INFO: Autoformat on save
    vim.api.nvim_create_autocmd("BufWritePre", {
      pattern = { "*.js", "*.jsx", "*.ts", "*.tsx", "*.json", "*.css", "*.scss", "*.html", "*.py" },
      callback = function()
        vim.lsp.buf.format({ async = false })
      end,
    })
  end,
}
