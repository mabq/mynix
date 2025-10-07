return {
  'mbbill/undotree',
  config = function()
    vim.keymap.set('n', '<leader>u', '<cmd>UndotreeToggle<cr> | <cmd>wincmd h<cr>')
  end,
}
