-- INFO: Automatically save the last colorscheme used
vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function(args)
    vim.api.nvim_set_hl(0, "CursorColumn", { bg = "#3a3a3a", blend = 20 })
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

-- INFO: Disable automatic comment continuation
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "c", "cpp", "java", "javascript", "typescript", "rust", "go" },
  callback = function()
    vim.opt_local.formatoptions:remove({ "r", "o" })
  end,
})

-- INFO: Highlight text on yank
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})