return {
  'rose-pine/neovim',
  name = 'rose-pine',
  config = function()
    require('rose-pine').setup {
      -- https://github.com/rose-pine/neovim?tab=readme-ov-file#options
      variant = 'main', -- auto, main, moon, or dawn
      styles = {
        bold = false,
        italic = false,
      },
    }
    vim.cmd.colorscheme 'rose-pine'
  end,
}
