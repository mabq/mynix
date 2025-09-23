return {
    -- TODO: check folke/lazydev.nvim completion instructions with blink
    -- NOTE: <C-x><X-l> completes the whole line
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
        --  `nvim-cmp` does not ship with all sources by default.
        --  They are split into multiple repos for maintenance purposes.
        'hrsh7th/cmp-path',
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-cmdline',
        'hrsh7th/cmp-emoji',
        {
            -- Snippet Engine for Neovim written in Lua.
            'L3MON4D3/LuaSnip',
            -- follow latest release.
            version = 'v2.*', -- Replace <CurrentMajor> by the latest released major (first number of latest release)
            -- install jsregexp (optional!).
            build = 'make install_jsregexp',
            dependencies = {
                -- `friendly-snippets` contains a variety of premade snippets.
                -- See the README about individual language/framework/plugin snippets:
                -- https://github.com/rafamadriz/friendly-snippets
                {
                    'rafamadriz/friendly-snippets',
                    config = function()
                        require('luasnip.loaders.from_vscode').lazy_load()
                    end,
                },
                -- LuaSnip completion source for nvim-cmp
                'saadparwaiz1/cmp_luasnip',
            },
        },
    },
    config = function()
        local cmp = require 'cmp'

        local luasnip = require 'luasnip'
        luasnip.config.setup {}
        luasnip.filetype_extend('javascript', { 'jsdoc' })

        cmp.setup {
            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                end,
            },
            completion = { completeopt = 'menu,menuone,noinsert' },

            -- For an understanding of why these mappings were chosen, you will need to read `:help ins-completion`
            mapping = cmp.mapping.preset.insert {
                ['<C-n>'] = cmp.mapping.select_next_item(),
                ['<C-p>'] = cmp.mapping.select_prev_item(),

                -- Scroll the documentation window [b]ack / [f]orward
                ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                ['<C-f>'] = cmp.mapping.scroll_docs(4),

                -- This will auto-import if your LSP supports it.
                ['<C-y>'] = cmp.mapping.confirm { select = true },

                -- Manually trigger a completion from nvim-cmp.
                ['<C-Space>'] = cmp.mapping.complete {},

                -- Jump between completion sections
                ['<C-l>'] = cmp.mapping(function()
                    if luasnip.expand_or_locally_jumpable() then
                        luasnip.expand_or_jump()
                    end
                end, { 'i', 's' }),
                ['<C-h>'] = cmp.mapping(function()
                    if luasnip.locally_jumpable(-1) then
                        luasnip.jump(-1)
                    end
                end, { 'i', 's' }),
            },

            sources = {
                {
                    name = 'lazydev',
                    -- set group index to 0 to skip loading LuaLS completions as lazydev recommends it
                    group_index = 0,
                },
                { name = 'nvim_lsp' },
                { name = 'luasnip' },
                { name = 'buffer' },
                { name = 'path' },
                { name = 'emoji' },
            },
        }

        vim.diagnostic.config {
            -- update_in_insert = true,
            float = {
                focusable = false,
                style = 'minimal',
                border = 'rounded',
                source = 'always',
                header = '',
                prefix = '',
            },
        }
    end,
}
