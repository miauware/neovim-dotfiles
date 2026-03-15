return {
  -- INFO: plugin for create,save and delete sessions
  "olimorris/persisted.nvim",
  config = function()
    require("persisted").setup()
  end,
}
