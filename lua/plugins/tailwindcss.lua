-- INFO: Plugin to configure Tailwind CSS LSP using lazy.nvim (Neovim ≥ 0.11)
return {
  'neovim/nvim-lspconfig',
  config = function()
    -- INFO: Define Tailwind CSS LSP configuration
    vim.lsp.config.tailwindcss = {
      filetypes = {
        'html', 'css', 'scss', 'javascript', 'javascriptreact',
        'typescript', 'typescriptreact', 'django-html',
      },
      init_options = {
        userLanguages = {
          ['django-html'] = 'html',
        },
      },
      settings = {
        tailwindCSS = {
          experimental = {
            classRegex = {
              -- INFO: Recognizes Tailwind CSS classes inside Django HTML templates
              { "class\\s*=\\s*['\"]([^'\"]*)['\"]", "class\\s*=\\s*['\"]([^'\"]*)['\"]" },
            },
          },
        },
      },
    }

    -- INFO: Try to start Tailwind CSS LSP
    local ok, _ = pcall(vim.lsp.start, vim.lsp.config.tailwindcss)
    if not ok then
      vim.notify("Failed to start Tailwind CSS LSP", vim.log.levels.WARN)
    end
  end,
}
