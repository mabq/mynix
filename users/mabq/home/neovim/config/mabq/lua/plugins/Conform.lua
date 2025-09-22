return {
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  keys = {
    {
      '<leader>f',
      function()
        require('conform').format()
      end,
      mode = '',
      desc = 'Format buffer',
    },
  },
  opts = {
    formatters_by_ft = {
      lua = { 'stylua' },
      css = { 'biome' },
      nix = { 'alejandra' },
      javascript = { 'biome' },
      typescript = { 'biome' },
      json = { 'biome' },
      jsonc = { 'biome' },
      markdown = { 'biome' },
      sh = { 'shfmt' },
    },
    default_format_opts = {
      async = true,
      lsp_format = 'fallback',
    },
    format_on_save = true,
    notify_on_error = true,
    notify_no_formatters = true,
  },
}

-- Notes:
--
--   Install formatters using you package manager. For a list of formatter, see https://github.com/stevearc/conform.nvim?tab=readme-ov-file#formatters
--
--   Use:
--     - `:checkhealth conform` to verify it has been setup correctly.
--     - `:ConformInfo` to verify a formatter is attached.
--
--   You can run multiple formatters sequentially or stop after first, for examples see https://github.com/stevearc/conform.nvim?tab=readme-ov-file#setup
