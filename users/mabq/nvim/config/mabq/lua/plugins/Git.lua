vim.g.lazygit_floating_window_winblend = 1 -- transparency of floating window
return {
  {
    'folke/snacks.nvim',
    lazy = false,
    opts = {
      lazygit = {},
    },
    keys = {
      -- stylua: ignore
      { '<leader>gg', function() Snacks.lazygit() end, desc = 'Lazygit', },
    },
  },
  {
    -- Adds git related signs to the gutter, as well as utilities for managing changes.
    -- See `:h gitsigns` to understand what the configuration keys do.
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    },
  },
}

-- Notes:
--   Use `:checkhealth snacks` to verify evertyhting is setup correctly.
