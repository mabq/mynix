local servers = {
  lua_ls = {
    settings = {
      Lua = {
        diagnostics = {
          globals = { 'vim' }, -- fix undefined global vim
        },
      },
    },
  },
  bashls = {},
}

local formatters = {
  'biome',
  'stylua',
}

return {
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    dependencies = {
      { 'mason-org/mason.nvim', opts = {} },
      { 'mason-org/mason-lspconfig.nvim' }, -- do not initiallize this one with `opts = {}`!, it will cause duplicate attached servers
    },
    opts = {
      ensure_installed = vim.list_extend(vim.tbl_keys(servers), formatters),
    },
  },

  -- LSP
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'saghen/blink.cmp',
      { 'j-hui/fidget.nvim', opts = {} }, -- useful LSP status updates
    },
    config = function()
      -- for keymaps see `:h lsp-defaults` and `:h diagnostic-defaults`

      vim.diagnostic.config {
        virtual_text = true,
      }

      local extra_completion_capabilities = require('blink.cmp').get_lsp_capabilities()
      for server_name, server_setup in pairs(servers) do
        server_setup.capabilities = vim.tbl_deep_extend('force', {}, extra_completion_capabilities, server_setup.capabilities or {})
        require('lspconfig')[server_name].setup(server_setup)
      end
    end,
  },
  {
    'folke/lazydev.nvim', -- LuaLS setup for Neovim
    ft = 'lua',
    opts = {
      library = {
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },
  {
    'pmizio/typescript-tools.nvim', -- Better TypeScript LPS with support for styled-components
    dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
    opts = {
      tsserver_plugins = { '@styled/typescript-styled-plugin' },
    },
  },

  -- Autoformat
  {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      -- `gq` uses the LSP, see `:h lsp-config`
      -- stylua: ignore
      { '<leader>f', function() require('conform').format() end, mode = '', desc = 'Format buffer', },
    },
    opts = {
      formatters_by_ft = {
        -- See https://github.com/stevearc/conform.nvim?tab=readme-ov-file#formatters
        -- Run multiple formatters sequentially or stop after first, see https://github.com/stevearc/conform.nvim?tab=readme-ov-file#setup
        lua = { 'stylua' },
        css = { 'biome' },
        javascript = { 'biome' },
        typescript = { 'biome' },
        json = { 'biome' },
        jsonc = { 'biome' },
        markdown = { 'biome' },
      },
      default_format_opts = {
        asyng = true,
        lsp_format = 'fallback', -- LSP formatting is used when no other formatters are available
      },
      format_on_save = true,
      notify_on_error = true,
      notify_no_formatters = true,
    },
  },

  -- Autocompletion
  {
    'saghen/blink.cmp',
    event = 'VimEnter',
    version = '1.*',
    dependencies = {
      'rafamadriz/friendly-snippets',
      'moyiz/blink-emoji.nvim',
      'folke/lazydev.nvim',
    },
    opts = {
      keymap = { preset = 'default' }, -- similar to built-in completion keymaps, see https://cmp.saghen.dev/configuration/keymap#default
      signature = { enabled = true }, -- show a signature help window while you type arguments for a function, use `Ctrl-k` to toggle it manually
      appearance = { nerd_font_variant = 'mono' },
      completion = {
        documentation = {
          auto_show = false, -- set to true to auto-show documentation after a delay
          auto_show_delay_ms = 500,
        },
      },
      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer', 'lazydev', 'emoji' },
        providers = {
          lazydev = {
            module = 'lazydev.integrations.blink',
            score_offset = 100,
          },
          emoji = {
            module = 'blink-emoji',
            score_offset = 15,
          },
        },
      },
      fuzzy = { implementation = 'prefer_rust_with_warning' },
    },
    opts_extend = { 'sources.default' },
  },
}

-- LSP ------------------------------------------------------------------------
--
-- Must watch [Understanding Neovim #7 - Language Server Protocol](https://www.youtube.com/watch?v=HL7b63Hrc8U&list=PLx2ksyallYzW4WNYHD9xOFrPRYGlntAft&index=7).
-- Read `:h lsp`.
--
-- Verify setup:
--   Use `:checkhealth vim.lsp` to verify an LSP is attached to the buffer and everything is setup correctly.
--   Use `:=vim.lsp.get_clients()[1].server_capabilities` to check attach LSP server capabilities.
--
-- Servers:
--   Use nvim-lspconfig names in the table, not Mason names.
--   For lspconfig server names per file type see https://github.com/mason-org/mason-lspconfig.nvim/blob/main/lua/mason-lspconfig/filetype_mappings.lua
--   Pass a table with LSP configuration options to override defaults, see `:h lsp` and https://github.com/nvim-lua/kickstart.nvim/blob/3338d3920620861f8313a2745fd5d2be39f39534/init.lua#L667.
--   See what settings you can customize for each LSP on their websites, e.g. to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
--
-- JavaScript / TypeScript:
--   Replaced `ts_ls` (`typescript-language-server`) with 'pmizio/typescript-tools.nvim'.
--   `ts_ls` does not support Styled-Components and is supposed to be awefully slow on big projects.
--   `typescript-tools` has more commands than the ones binded to keymaps, use `:TSTools<Tab>` to see them.
--

-- Autoformat -----------------------------------------------------------------
--
-- Conform makes it really easy to specify one or more formatters per language. If you do not specify any formatter it will fallback to LSP formatting.
--   Use `:checkhealth conform` to verify it has been setup correctly.
--   Use `:ConformInfo` to verify a formatter is attached.
--

-- Autocompletion -------------------------------------------------------------
--
--
