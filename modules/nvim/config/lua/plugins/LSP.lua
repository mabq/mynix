return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'j-hui/fidget.nvim', opts = {} }, -- shows lsp loading
      { 'mason-org/mason.nvim', opts = {} }, -- just to try things out
    },
    config = function()
      -- Install LSPs with your package manager, see notes below
      vim.lsp.enable 'lua_ls' -- lua-language-server
      vim.lsp.enable 'nixd' -- nixd
      vim.lsp.enable 'bashls' -- bash-language-server

      -- vim.lsp.config('*', {}) -- see `:h vim.lsp.config()`

      vim.diagnostic.config { -- see `:h vim.diagnostic.Opts`
        underline = false,
        virtual_text = false, -- append to line
        -- virtual_lines = true, -- lines below
      }
    end,
  },
  {
    'pmizio/typescript-tools.nvim',
    dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
    opts = {
      tsserver_plugins = { '@styled/typescript-styled-plugin' },
    },
  },
  {
    'folke/lazydev.nvim', -- lsp for Neovim configuration
    ft = 'lua',
    opts = {
      library = {
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },
}

-- Notes:
--
--   About LSP:
--     [Understanding Neovim #7 - Language Server Protocol](https://www.youtube.com/watch?v=HL7b63Hrc8U&list=PLx2ksyallYzW4WNYHD9xOFrPRYGlntAft&index=7).
--     Read `:h lsp`
--
--   Verify setup:
--     Use `:LspInfo` to verify an LSP is attached to the buffer and everything is setup correctly.
--     If not attached, see [common pitfalls](https://youtu.be/UVcC5ifbXL8?si=LJ8-DBjCPvQ3DZmr&t=439)
--
--   Keymaps:
--     `:h lsp-defaults`
--     `:h diagnostic-defaults`
--
--   Capabilities:
--     Neovim 11 already includes the capabilities that we used to add with Blink, so that code is not necessary anymore.
--     To see Neovim client LSP builtin capabilities run `:=vim.lsp.protocol.make_client_capabilities()`.
--     To see attached LSP capabilities run `:=vim.lsp.get_clients()[1].server_capabilities`.
--
--   Servers:
--     Install LSPs using your package manager, that way they are available for the whole system, not just Neovim.
--     Nvim-lspconfig uses custom names, e.g. for the `lua-language-server` it uses `lua_ls`. You can search here:
--       - [Mason - lspconfig](https://github.com/mason-org/mason-lspconfig.nvim/blob/main/lua/mason-lspconfig/filetype_mappings.lua)
--       - [Nvim-lspconfig - configs](https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md)
--     Customize the behavior of each LSP by passing a table. Check each LSP website for available options.
--       - `:h lsp`
--       - [Lua settings](https://github.com/nvim-lua/kickstart.nvim/blob/3338d3920620861f8313a2745fd5d2be39f39534/init.lua#L667)
--
--   JavaScript / TypeScript:
--     Replaced `typescript-language-server` (`ts_ls`) with 'pmizio/typescript-tools.nvim'.
--     `ts_ls` does not support Styled-Components and is supposed to be awefully slow on big projects.
--     `typescript-tools` has more commands than the ones binded to keymaps, use `:TSTools<Tab>` to see them.
--
