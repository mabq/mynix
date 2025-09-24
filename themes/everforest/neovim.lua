return {
  'neanias/everforest-nvim',
  name = 'everforest',
  lazy = false,
  priority = 1000,
  config = function()
    require('everforest').setup {
      -- https://github.com/neanias/everforest-nvim?tab=readme-ov-file#configuration
      background = 'hard',
    }
    vim.cmd.colorscheme 'everforest'
  end,
}
