-- INFO: Plugin to configure Tailwindcss LSP using lazy.nvim
return {
  'neovim/nvim-lspconfig',
  config = function()
    local lspconfig = require('lspconfig')

    lspconfig.tailwindcss.setup {
      filetypes = {
        'html', 'css', 'scss', 'javascript', 'javascriptreact',
        'typescript', 'typescriptreact', 'django-html'
      },
      init_options = {
        userLanguages = {
          ['django-html'] = 'html'
        }
      },
      settings = {
        tailwindCSS = {
          experimental = {
            classRegex = {
              -- INFO: Recognizes Tailwindcss classes in html django
              { "class\\s*=\\s*['\"]([^'\"]*)['\"]", "class\\s*=\\s*['\"]([^'\"]*)['\"]" }
            }
          }
        }
      }
    }
  end
}
