return {
  'ellisonleao/gruvbox.nvim',
  name = 'gruvbox',
  lazy = false,
  priority = 1000,
  config = function()
    require('gruvbox').setup {
      -- https://github.com/ellisonleao/gruvbox.nvim?tab=readme-ov-file#configuration
      bold = false,
      italic = {
        strings = false,
        emphasis = false,
        folds = false,
      },
    }
    vim.cmd.colorscheme 'gruvbox'
  end,
}
