return {
  'EdenEast/nightfox.nvim',
  name = 'nightfox',
  lazy = false,
  priority = 1000,
  config = function()
    require('nightfox').setup {
      -- https://github.com/EdenEast/nightfox.nvim?tab=readme-ov-file#configuration
      options = {
        styles = {
          comments = 'italic',
        },
      },
    }
    vim.cmd.colorscheme 'nordfox'
  end,
}
