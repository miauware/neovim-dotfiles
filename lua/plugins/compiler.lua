return {
  -- INFO: plugin for compile keybinding on f5
  "Zeioth/compiler.nvim",
  lazy = false,
  dependencies = {
    { "stevearc/overseer.nvim", version = "v1.6.0" },
    "nvim-telescope/telescope.nvim",
  },
  config = function()
    require("compiler").setup({})
    require("overseer").setup()


    vim.keymap.set('n', '<F5>', "<cmd>CompilerOpen<cr>", { noremap = true, silent = true })
    vim.keymap.set('i', '<F5>', "<cmd>CompilerOpen<cr>", { noremap = true, silent = true })  -- Atalho no modo insert

    vim.keymap.set('n', '<F6>', function()
      vim.cmd("CompilerToggleResults")
      local overseer = require("overseer")
      local tasks = overseer.list_tasks({})
      for _, task in ipairs(tasks) do
        if not task:is_complete() then
          task:stop()
        end
      end

      for _, task in ipairs(tasks) do
        if task:is_complete() then
          task:dispose()
        end
      end
    end, { noremap = true, silent = true })
    vim.keymap.set('i', '<F6>', function()
      vim.cmd("CompilerToggleResults")
      local overseer = require("overseer")
      local tasks = overseer.list_tasks({})
      for _, task in ipairs(tasks) do
        if not task:is_complete() then
          task:stop()
        end
      end

      for _, task in ipairs(tasks) do
        if task:is_complete() then
          task:dispose()
        end
      end
    end, { noremap = true, silent = true })

    vim.keymap.set('n', '<F7>', "<cmd>CompilerStop<cr><cmd>CompilerRedo<cr>", { noremap = true, silent = true })
    vim.keymap.set('i', '<F7>', "<cmd>CompilerStop<cr><cmd>CompilerRedo<cr>", { noremap = true, silent = true })
  end,
}
