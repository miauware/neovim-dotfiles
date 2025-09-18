vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable',
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)
require('lazy').setup({
  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',
  'tpope/vim-sleuth',

  { import = 'plugins' },
}, {})


local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})
require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
      },
    },
  },
}

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    underline = true,
    virtual_text = true,
    virtual_text_prefix = "",
    update_in_insert=true,
    signs=true,
  })
  local signs = { Error = "❌", Warn = "", Hint = "💡", Info = "ℹ️" }
  for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
  end
pcall(require('telescope').load_extension, 'fzf')
require('nvim-treesitter.configs').setup {
  ensure_installed = { 'c','css', 'cpp', 'go','markdown', 'lua', 'python', 'rust', 'tsx', 'typescript', 'vimdoc', 'vim' },
  auto_install = false,

  highlight = { enable = true },
  indent = { enable = true },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<c-space>',
      node_incremental = '<c-space>',
      scope_incremental = '<c-s>',
      node_decremental = '<M-space>',
    },
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        ['aa'] = '@parameter.outer',
        ['ia'] = '@parameter.inner',
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
      },
    },
    move = {
      enable = true,
      set_jumps = true,
      goto_next_start = {
        [']m'] = '@function.outer',
        [']]'] = '@class.outer',
      },
      goto_next_end = {
        [']M'] = '@function.outer',
        [']['] = '@class.outer',
      },
      goto_previous_start = {
        ['[m'] = '@function.outer',
        ['[['] = '@class.outer',
      },
      goto_previous_end = {
        ['[M'] = '@function.outer',
        ['[]'] = '@class.outer',
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ['<leader>a'] = '@parameter.inner',
      },
      swap_previous = {
        ['<leader>A'] = '@parameter.inner',
      },
    },
  },
}
local on_attach = function(_, bufnr)
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

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
  nmap('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders')
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })
end
local function tbl_add_reverse_lookup(tbl)
  for k, v in pairs(tbl) do
    tbl[v] = k
  end
end
local servers = {
  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
}
require('neodev').setup()
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
-- INFO: configure LSP servers with mason-lspconfig (without setup_handlers)
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
}


for server_name, config in pairs(servers) do
  require('lspconfig')[server_name].setup {
    capabilities = capabilities,
    on_attach = on_attach,
    settings = config,
  }
end

local cmp = require 'cmp'
local luasnip = require 'luasnip'
require('luasnip.loaders.from_vscode').lazy_load()
luasnip.config.setup {}

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert {
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete {},
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Insert,
      select = true,
      completion = {completeopt = 'menuone,noselect'},
    },
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
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'buffer' },
    { name = 'path' },

  },

}
cmp.setup.cmdline('/', {
  sources = {
    { name = 'buffer' }
  }
})
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.o.cmdheight = 0
vim.opt.termguicolors = true
vim.cmd([[hi NvimTreeNormalNC guibg=NONE]])
vim.cmd([[highlight NvimTreeNormal guibg=NONE ctermbg=NONE]])
vim.g.nvim_tree_highlight_opened_files = 1
vim.api.nvim_set_option('cursorcolumn', true)
vim.api.nvim_set_option('cursorline', true)
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.o.hlsearch = false
vim.wo.number = true
vim.o.mouse = 'a'
vim.opt.mouse="a"
vim.o.clipboard = 'unnamedplus'
vim.o.breakindent = true
vim.o.undofile = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.wo.signcolumn = 'yes'
vim.o.updatetime = 250
vim.o.timeoutlen = 300
vim.o.completeopt = 'menuone,noselect'
vim.o.termguicolors = true
vim.wo.wrap = true
vim.o.linebreak = true
-- INFO: cursor color
vim.cmd('highlight Cursor guibg=#ab34eb')
-- Use colorscheme variable
local themes = require('colorscheme')
vim.cmd("colorscheme " .. themes.colorscheme)
require('keybindings')
vim.cmd 'aunmenu PopUp.How-to\\ disable\\ mouse'
vim.cmd 'aunmenu PopUp.-1-'


vim.api.nvim_command([[
  menu PopUp.Copy <cmd>normal! "+y<cr>
  menu PopUp.Paste <cmd>normal! "+p<cr>
  menu PopUp.Cut <cmd>normal! "+x<cr>
  menu PopUp.-Sep- <Nop>
  menu PopUp.Quit <cmd>quit<cr>
]])
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "c", "cpp", "java", "javascript", "typescript", "rust", "go" },
  callback = function()
    -- INFO: Prevent automatic comment continuation in //-style languages
    vim.opt_local.formatoptions:remove({ "r", "o" })
  end,
})

-- INFO: This autocommand writes the selected colorscheme to a Lua file
vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function(args)
    local theme = args.match
    local path = vim.fn.stdpath("config") .. "/lua/colorscheme.lua"
    local file = io.open(path, "w")
    if file then
      file:write('local M = {}\n')
      file:write('-- INFO: Set the color scheme you want here\n')
      file:write(string.format('M.colorscheme = "%s"\n', theme))
      file:write('return M\n')
      file:close()
    else
      vim.notify("Failed to write to colorscheme.lua", vim.log.levels.ERROR)
    end
  end,
})


