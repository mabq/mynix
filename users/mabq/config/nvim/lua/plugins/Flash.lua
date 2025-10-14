return {
  'folke/flash.nvim',
  event = 'VeryLazy',
  opts = {
    modes = {
      search = { enabled = false },
      char = { enabled = false },
    },
    highlight = {
      backdrop = false, -- do not gray out all text while using it
    },
  },
  keys = {
    -- stylua: ignore
    { 'f', mode = { 'n', 'x', 'o' }, function() require('flash').jump() end, desc = 'Flash', },
  },
}
