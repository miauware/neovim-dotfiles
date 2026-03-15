-- INFO: set keybindigs here
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>/', function()
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer' })

vim.keymap.set('n', '<leader>gf', require('telescope.builtin').git_files, { desc = 'Search [G]it [F]iles' })
vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })



 --NOTE: Custom hotkeys  -
-- INFO: Hotkey to save no Insert mode
function save_file_in_insert_mode()
    vim.cmd([[write]])
    vim.cmd([[startinsert]])
end
vim.api.nvim_set_keymap('i', '<C-S>', '<cmd>lua save_file_in_insert_mode()<CR>', { noremap = true })

-- INFO: Hotkey to create a new tab
vim.api.nvim_set_keymap('i', '<C-n>', '<ESC>:tabnew ', {noremap = true, silent = true})

-- INFO: Hotkeys for switch tab
vim.api.nvim_set_keymap('n', '<C-Right>', ':tabnext<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<C-Left>', ':tabprevious<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('i', '<C-Right>', '<Esc>:tabnext<CR>a', {noremap = true, silent = true})
vim.api.nvim_set_keymap('i', '<C-Left>', '<Esc>:tabprevious<CR>a', {noremap = true, silent = true})
vim.api.nvim_set_keymap('v', '<C-Right>', '<Esc>:tabnext<CR>gv', {noremap = true, silent = true})
vim.api.nvim_set_keymap('v', '<C-Left>', '<Esc>:tabprevious<CR>gv', {noremap = true, silent = true})
vim.api.nvim_set_keymap('c', '<C-Right>', '<C-C>:tabnext<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('c', '<C-Left>', '<C-C>:tabprevious<CR>', {noremap = true, silent = true})
-- INFO: Mapping to select text in insertion mode
vim.api.nvim_set_keymap('i', '<S-Left>', '<C-o>v', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<S-Right>', '<C-o>ve', { noremap = true, silent = true })

-- INFO: Map the Tab key to insert 3 spaces
vim.api.nvim_set_keymap('i', '<Tab>', '    ', { noremap = true, silent = true })


-- INFO: Duplicate current line above in insert mode
vim.api.nvim_set_keymap('i', '<C-d>', '<Esc>yyP`^a', { noremap = true, silent = true })
-- INFO: Mapping for copy (ctrl+c)
vim.api.nvim_set_keymap('n', '<C-c>', '"+y', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<C-c>', '"+y', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<C-c>', '<ESC>"+y', { noremap = true, silent = true })
vim.api.nvim_set_keymap('c', '<C-c>', '<C-c>"+y', { noremap = true, silent = true })

-- INFO: Mapping for paste (CTRL V)
vim.api.nvim_set_keymap('n', '<C-v>', '"+p', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<C-v>', '"+p', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<C-v>', '<ESC>"+pa', { noremap = true, silent = true })
vim.api.nvim_set_keymap('c', '<C-v>', '<C-c>"+p', { noremap = true, silent = true })

-- INFO: Mapping to cut (ctrl+x)
vim.api.nvim_set_keymap('n', '<C-x>', '"+x', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<C-x>', '"+x', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<C-x>', '<ESC>"+x', { noremap = true, silent = true })
vim.api.nvim_set_keymap('c', '<C-x>', '<C-c>"+x', { noremap = true, silent = true })

-- INFO: Mapping for Undo (Ctrl Z)
vim.api.nvim_set_keymap('', '<C-z>', '<cmd>undo<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<C-z>', '<cmd>undo<CR>', { noremap = true, silent = true })
-- INFO: Mapeamento for redo (ctrl+r)
vim.api.nvim_set_keymap('', '<C-r>', '<cmd>redo<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<C-r>', '<cmd>redo<CR>', { noremap = true, silent = true })

-- INFO: Mapping to save (CTRL S)
vim.api.nvim_set_keymap('n', '<C-s>', '<cmd>write<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<C-s>', '<cmd>write<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<C-s>', '<cmd>write<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('c', '<C-s>', '<cmd>write<CR>', { noremap = true, silent = true })

-- INFO: Mapping to leave (ctrl q)
vim.api.nvim_set_keymap('n', '<C-q>', '<cmd>quit<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<C-q>', '<cmd>quit<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<C-q>', '<cmd>quit<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('c', '<C-q>', '<cmd>quit<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<RightMouse>', '<cmd>popup! PopUp<cr>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<RightMouse>', '<C-\\><C-g>gv<cmd>popup! PopUp<cr>', { noremap = true, silent = true })