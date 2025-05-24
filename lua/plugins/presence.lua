return{
  -- INFO: discord rcp plugin
  'andweeb/presence.nvim',
  event = 'VimEnter',
  config = function()
    require("presence").setup({
      auto_update = true,
      neovim_image_text = "Neovim Text Editor",
      main_image = "neovim",
      client_id = "793271441293967371",
      log_level = nil,
      debounce_timeout = 10,
      enable_line_number = false,
      blacklist = {},
      buttons = true,
      file_assets = {},
      show_time = true,
      editing_text = "📝 Editing %s",
      file_explorer_text = "🔎 Looking for %s",
      git_commit_text = "🖋️ Committing Changes",
      plugin_manager_text = "🔧 Managing plugins",
      reading_text = "📰 Reading %s",
      workspace_text = "💼 Working on %s",
      line_number_text = "📃 Line %s of %s",
    })
  end,
}