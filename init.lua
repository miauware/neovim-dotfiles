require('vim._core.ui2').enable()
-- INFO: Set global leaders
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
-- INFO: Lazy.nvim bootstrap
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable',
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',
  'tpope/vim-sleuth',
  { import = 'plugins' },
}, {})

-- INFO: LSP diagnostics customization (Neovim 0.12+)
vim.diagnostic.config({
  underline = true,
  virtual_text = {
    prefix = "",
  },
  update_in_insert = true,
  signs = true,
})

local signs = { Error = "❌", Warn = "", Hint = "💡", Info = "ℹ️" }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- INFO: LSP on_attach function
local on_attach = function(_, bufnr)
  local nmap = function(keys, func, desc)
    if desc then desc = 'LSP: ' .. desc end
    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
  nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
  nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
  nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
  nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
  nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  nmap('<leader>wl', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, '[W]orkspace [L]ist Folders')

  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })
end

-- INFO: LSP servers configuration
local servers = {
  lua_ls = {
    Lua = {
      diagnostics = {
        globals = { "vim" }, -- INFO: fix undefined global vim
      },
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
}

require('neodev').setup()
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

local mason_lspconfig = require('mason-lspconfig')

-- INFO: Configure servers using vim.lsp.config (Neovim 0.11+)
for server_name, config in pairs(servers) do
  vim.lsp.config[server_name] = {
    capabilities = capabilities,
    on_attach = on_attach,
    settings = config,
  }
end

-- INFO: Start LSP servers once Mason ensures they are installed
mason_lspconfig.setup({
  ensure_installed = vim.tbl_keys(servers),
})

for server_name, _ in pairs(servers) do
  if vim.lsp.config[server_name] then
    local ok, _ = pcall(vim.lsp.start, vim.lsp.config[server_name])
    if not ok then
      vim.notify("Failed to start LSP: " .. server_name, vim.log.levels.WARN)
    end
  end
end

-- INFO: nvim-cmp setup
local cmp = require('cmp')
local luasnip = require('luasnip')
require('luasnip.loaders.from_vscode').lazy_load()
luasnip.config.setup({})

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete({}),
    ['<CR>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Insert,
      select = true,
      completion = { completeopt = 'menuone,noselect' },
    }),
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_locally_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.locally_jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'buffer' },
    { name = 'path' },
  },
})

cmp.setup.cmdline('/', { sources = { { name = 'buffer' } } })

-- INFO: Load colorscheme
local themes = require('colorscheme')
vim.cmd("colorscheme " .. themes.colorscheme)

require('keybindings')
require('options')
require('autocmd')

-- INFO: Simplify right-click popup menu
vim.cmd('aunmenu PopUp.How-to\\ disable\\ mouse')
vim.cmd('aunmenu PopUp.-1-')
vim.api.nvim_command([[
  menu PopUp.Copy <cmd>normal! "+y<cr>
  menu PopUp.Paste <cmd>normal! "+p<cr>
  menu PopUp.Cut <cmd>normal! "+x<cr>
  menu PopUp.-Sep- <Nop>
  menu PopUp.Quit <cmd>quit<cr>
]])


