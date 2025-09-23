return {
  'catgoose/nvim-colorizer.lua', -- show hex colors
  opts = {},
  keys = {
    -- stylua: ignore start
    { "<leader>#", mode = { "n" }, "<cmd>ColorizerToggle<cr>", desc = "Nvim-colorizer: Toggle", },
  },
}
