return {
  'rebelot/kanagawa.nvim',
  name = 'kanagawa',
  lazy = false,
  priority = 1000,
  config = function()
    require('kanagawa').setup {
      -- https://github.com/rebelot/kanagawa.nvim?tab=readme-ov-file#configuration
      theme = 'wave', -- wave | lotus | dragon
      keywordStyle = { italic = false },
      overrides = function()
        return {
          FloatBorder = { bg = 'none' }, -- remove float border background (Yazi).
        }
      end,
    }
    vim.cmd.colorscheme 'kanagawa'
  end,
}
