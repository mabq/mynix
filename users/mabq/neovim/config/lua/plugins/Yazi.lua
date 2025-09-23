return {
  'mikavilpas/yazi.nvim',
  event = 'VeryLazy',
  dependencies = {
    { 'nvim-lua/plenary.nvim', lazy = true },
  },
  opts = {
    highlight_groups = {
      -- Do not change the background color of the selected buffer.
      hovered_buffer = { bg = 'none' },
      hovered_buffer_in_same_directory = { bg = 'none' },
    },
  },
  keys = {
    {
      '<C-y>',
      mode = { 'n', 'v' },
      '<cmd>Yazi<cr>',
      desc = 'Open yazi at the current file',
    },
  },
}
