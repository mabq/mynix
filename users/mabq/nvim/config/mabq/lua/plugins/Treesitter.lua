return {
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    main = 'nvim-treesitter.configs', -- Sets main module to use for opts
    opts = {
      ensure_installed = {
        -- https://github.com/nvim-treesitter/nvim-treesitter?tab=readme-ov-file#supported-languages
        'bash',
        'c',
        'diff',
        'html',
        'lua',
        'luadoc',
        'markdown',
        'markdown_inline',
        'nix',
        'query',
        'vim',
        'vimdoc',
      },
      auto_install = true,
      highlight = {
        enable = true,
        -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules. If you are experiencing weird indenting issues, add the language to the list of additional_vim_regex_highlighting and disabled languages for indent.
        -- additional_vim_regex_highlighting = { 'ruby' },
      },
      indent = {
        enable = true,
        -- disable = { 'ruby' },
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = '<right>',
          node_incremental = '<right>',
          scope_incremental = false,
          node_decremental = '<left>',
        },
      },
    },
  },
  -- {
  --   'nvim-treesitter/nvim-treesitter-textobjects',
  -- },
  -- {
  --   'nvim-treesitter/nvim-treesitter-context',
  --   opts = {},
  -- },
  -- {
  --   -- Use treesitter to auto close and auto rename html tag (works with all major syntax extensions)
  --   --   Will not work unless you have treesitter parsers (like html) installed for a given filetype.
  --   'windwp/nvim-ts-autotag',
  --   opts = {
  --       enable_close = true, -- auto close tags
  --       enable_rename = true, -- auto rename pairs of tags
  --       enable_close_on_slash = false, -- auto close on trailing </
  --   },
  -- },
}

-- Notes:
--   [Understanding Neovim - Treesitter](https://www.youtube.com/watch?v=kYXcxJxJVxQ&list=PLx2ksyallYzW4WNYHD9xOFrPRYGlntAft&index=4)
--   [Understanding Neovim - Text objects and Incremental Selection](https://www.youtube.com/watch?v=ff0GYrK3nT0&list=PLx2ksyallYzW4WNYHD9xOFrPRYGlntAft&index=5)
--   [Treesitter basics and installation](https://www.youtube.com/watch?v=MpnjYb-t12A&list=PLep05UYkc6wTyBe7kPjQFWVXTlhKeQejM&index=6)
--   `:help lsp-vs-treesitter`
--   `:help nvim-treesitter`
--   `:checkhealth nvim-treesitter`
--   `:Inspect` - shows all currently applied highlights for text under cursor.
--   `:InspectTree` - shows the AST

--   If you get an error, try syncing all plugins with Lazy.
