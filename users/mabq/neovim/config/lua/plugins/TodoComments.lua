return {
  'folke/todo-comments.nvim', -- nice todo marks viewer
  opts = {},
  cmd = 'TodoTrouble',
  keys = {
    { '<leader>vT', '<cmd>TodoTrouble toggle<cr>', desc = 'TodoTrouble: View todo list' }, -- be careful not to override a Trouble keybind (also starts with `<leader>v`)
  },
}
