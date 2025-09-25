return {
  'NMAC427/guess-indent.nvim',
  opts = {},
}

-- Indentation is controlled by the following vim options:
--
-- - `tabstop`: Number of spaces to use for a `<Tab>`.
--
-- - `shiftwidth`: Number of spaces to use for each step of (auto)indent like
--   `>>`, `<<`, `=`.
--
-- - `softtabstop`: Number of spaces that a `<Tab>` counts for while performing
--   editing operations (insert mode).

-- GuessIndent Will automatically adjust these options (for the current buffer)
-- by analizing contents of the file. It also checks for an `.editorconfig`
-- file but does NOT check for any formatter configuration file like
-- `.stylua.toml` or `.prettierrc`.

-- When there is no `.editorconfig` and the content of the buffer does not
-- provide enough information to correctly adjust these options, indentation
-- will work as you specified in the formatter configuration file. When this
-- happens, you can:
--
-- - Manually change the `tabstop` value to match the formatter's value
--   with `:set tabstop=<value>`. Note that `shiftwidth` and `softtabstop`
--   are configured to mimic the value of `tabstop`, so you don't need to
--   change those.
--
-- - If you don't want to do that every time you open a buffer of that file
--   type, you can configure neovim to use a different `tabstop` value for
--   that specific file type in `~/.config/nvim/after/ftplugin/<filetype>.lua`.
