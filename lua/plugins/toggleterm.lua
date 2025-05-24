return {
  -- INFO: plugin terminal on press ctrl + t
  "akinsho/toggleterm.nvim",
  version = "*",
  config = function()
    require("toggleterm").setup({
    	  size = 22,
  open_mapping = [[<c-t>]],
  hide_numbers = true, 
  shade_filetypes = {},
  shade_terminals = true,
  start_in_insert = true,
  insert_mappings = true,
  terminal_mappings = true,
  persist_size = true,
  direction = 'float',
  close_on_exit = true,
  float_opts = {
       border = 'curved', 
    winblend = 3,
  }

    })
  end,
}




