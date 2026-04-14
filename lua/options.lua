-- INFO: UI and editor options
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.o.cmdheight = 0
vim.opt.termguicolors = true
vim.cmd([[hi NvimTreeNormalNC guibg=NONE]])
vim.cmd([[highlight NvimTreeNormal guibg=NONE ctermbg=NONE]])
-- INFO: Cursor color
vim.cmd('highlight Cursor guibg=#ab34eb')
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
-- NOTE: CursorColumn controls the vertical cursor line highlight
vim.api.nvim_set_hl(0, "CursorColumn", {
  bg = "#3a3a3a",
  blend = 20, -- INFO: 0 = solid, 100 = invisible
})

-- NOTE: optional horizontal cursor line
vim.api.nvim_set_hl(0, "CursorLine", {
  bg = "#2a2a2a",
  blend = 20,
})
