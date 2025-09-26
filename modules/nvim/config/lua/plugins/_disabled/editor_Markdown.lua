return {
    'MeanderingProgrammer/render-markdown.nvim',
    -- dependencies = { 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
    -- dependencies = {'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {
        heading = {
            sign = false,
            icons = {},
        },
        bullet = {
            enabled = false,
        },
        link = {
            enabled = false,
        },
    },
}
