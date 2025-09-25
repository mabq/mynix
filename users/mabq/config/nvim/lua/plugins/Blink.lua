return {
  'saghen/blink.cmp', -- autocompletion
  event = 'VimEnter',
  version = '1.*',
  dependencies = {
    'rafamadriz/friendly-snippets',
    'moyiz/blink-emoji.nvim',
    'folke/lazydev.nvim',
  },
  opts = {
    keymap = {
      preset = 'default', -- see https://cmp.saghen.dev/configuration/keymap#default
      ['<C-h>'] = { 'show', 'show_documentation', 'hide_documentation' }, -- `Ctrl-Space` is used as tmux prefix
    },
    appearance = { nerd_font_variant = 'mono' },
    completion = {
      documentation = { auto_show = false }, -- only show the documentation popup when manually triggered
    },
    signature = { enabled = true }, -- or use `Ctrl-k` to toggle it manually
    sources = {
      default = { 'lsp', 'path', 'buffer', 'snippets', 'lazydev', 'emoji' },
      providers = {
        lazydev = {
          name = 'LazyDev',
          module = 'lazydev.integrations.blink',
          score_offset = 100,
        },
        emoji = {
          module = 'blink-emoji',
        },
      },
    },
    fuzzy = { implementation = 'prefer_rust_with_warning' },
  },
  opts_extend = { 'sources.default' },
}

-- Use `checkhealth blink.cmp` to verify everything is setup correctly.
