return {
  'catppuccin/nvim',
  name = 'catppuccin',
  lazy = false,
  priority = 1000,
  config = function()
    require('catppuccin').setup {
      -- https://github.com/catppuccin/nvim?tab=readme-ov-file#configuration
      flavour = 'mocha', -- latte, frappe, macchiato, mocha
      color_overrides = {},
      custom_highlights = {},
    }
    vim.cmd.colorscheme 'catppuccin'
  end,
}
