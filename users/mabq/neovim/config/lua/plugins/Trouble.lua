return {
  'folke/trouble.nvim',
  opts = {
    focus = true,
  },
  cmd = 'Trouble',
  keys = {
    { '<leader>vd', '<cmd>Trouble diagnostics toggle<cr>', desc = 'Trouble: View diagnostics' },
    { '<leader>vD', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>', desc = 'Trouble: View buffer diagnostics' },
    { '<leader>vl', '<cmd>Trouble loclist toggle<cr>', desc = 'Trouble: View location list' },
    { '<leader>vq', '<cmd>Trouble qflist toggle<cr>', desc = 'Trouble: View quickfix list' },
    { '<leader>vt', '<cmd>Trouble telescope_files toggle<cr>', desc = 'Trouble: View telescope files' }, -- see telescope config
  },
}
