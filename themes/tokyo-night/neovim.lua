return {
  'folke/tokyonight.nvim',
  priority = 1000,
  config = function()
    require('tokyonight').setup {
      style = 'night',
      styles = {
        comments = { italic = true },
        keywords = { italic = false },
      },
      on_highlights = function(hl, _)
        -- -- Customized colors for `night`:
        hl.CursorLine = {
          -- bg = '#1a1b26', -- same color, highlights line number
          bg = '#1c1d29', -- `:colorcolumn=[value|empty]`
        }
        hl.ColorColumn = {
          bg = '#1c1d29', -- `:colorcolumn=[value|empty]`
        }
        hl.Search = {
          bg = '#292E42', -- lighter constrast
          fg = '#c0caf5',
        }
        hl.LspReferenceRead = {
          bg = '#292E42', -- lighter constrast
        }
        hl.LspReferenceText = {
          bg = '#292E42',
        }
        hl.LspReferenceWrite = {
          bg = '#292E42',
        }
        hl.WinSeparator = {
          bold = true,
          fg = '#404464', -- lighter contrast
        }
      end,
    }
    vim.cmd.colorscheme 'tokyonight'
  end,
}
