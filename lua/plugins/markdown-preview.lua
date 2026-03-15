return {
  -- INFO: plugin for view markdown like git
  "iamcco/markdown-preview.nvim",
  cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
  build = "cd app && npm install && git restore .",
  init = function()
    vim.g.mkdp_filetypes = { "markdown" }
    vim.g.mkdp_auto_close = 0 -- INFO: auto close preview when switching buffers
  end,
  ft = { "markdown" },
}
