return {
  "rcarriga/nvim-notify",
  config = function()

    require("notify").setup({
      background_colour = "#000000",
    })

    -- INFO: setup Comment.nvim first (avoids noisy notifications)
    require("Comment").setup()

    -- INFO: filter Comment.nvim messages
    local notify = require("notify")

    vim.notify = function(msg, level, opts)
      if type(msg) == "string" and msg:find("Comment.nvim") then
        return
      end

      return notify(msg, level, opts)
    end

  end
}