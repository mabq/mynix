return {
  'nvim-telescope/telescope.nvim',
  event = 'VimEnter',
  branch = '0.1.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    { -- If encountering errors, see telescope-fzf-native README for installation instructions
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make',
      cond = function()
        return vim.fn.executable 'make' == 1
      end,
    },
    'nvim-tree/nvim-web-devicons',
    'folke/trouble.nvim', -- send results to Trouble
  },
  config = function()
    local actions = require 'telescope.actions'

    local open_with_trouble = require('trouble.sources.telescope').open -- sends the list to Trouble, overwritting any previous list
    local append_to_trouble = require('trouble.sources.telescope').add -- sends the list to Trouble, appending to any previous list

    require('telescope').setup { -- see `:help telescope.setup()` or https://github.com/nvim-telescope/telescope.nvim?tab=readme-ov-file#customization
      defaults = {
        mappings = {
          n = {
            ['q'] = actions.close,
            ['<c-t>'] = open_with_trouble,
            ['<c-a>'] = append_to_trouble,
          },
          i = {
            ['<c-t>'] = open_with_trouble,
            ['<c-a>'] = append_to_trouble,
          },
        },
      },
      pickers = {
        grep_string = {
          use_regex = true, -- enable regex
        },
      },
      extensions = {
        fzf = {
          fuzzy = false, -- exact matches only
        },
      },
    }

    require('telescope').load_extension 'fzf' -- enable fzf extension

    local builtin = require 'telescope.builtin'
    vim.keymap.set('n', '<C-f>', builtin.find_files, { desc = 'Telescope: Files' })
    vim.keymap.set('n', '<C-g>', builtin.git_files, { desc = 'Telescope: Git files' })
    vim.keymap.set('n', '<leader>tr', builtin.resume, { desc = 'Telescope: Resume' })
    vim.keymap.set('n', '<leader>tt', builtin.tagstack, { desc = 'Telescope: Tagstack' })
    vim.keymap.set('n', '<leader>tl', builtin.live_grep, { desc = 'Telescope: Live grep' }) -- already uses regex by default
    vim.keymap.set('n', '<leader>tg', function()
      builtin.grep_string { search = vim.fn.input 'Grep (regex) > ' }
    end, { desc = 'Telescope: Grep input' }) -- escape especial chars
    vim.keymap.set('n', '<leader>tw', builtin.grep_string, { desc = 'Telescope: Grep word under cursor' })
    vim.keymap.set('n', '<leader>tb', builtin.buffers, { desc = 'Telescope: Buffers' })
    vim.keymap.set('n', '<leader>ta', builtin.builtin, { desc = 'Telescope: All' })
    vim.keymap.set('n', '<leader>tk', builtin.keymaps, { desc = 'Telescope: Keymaps' })
    vim.keymap.set('n', '<leader>th', builtin.help_tags, { desc = 'Telescope: Help' })
  end,
}

--
-- Notes:
--
--   Use `:checkhealth telescope` to verify everything is setup correctly.
--
--   Each picker can be customized, see `:help telescope.builtin[.<picker-name>]`.
--   E.g. `grep_string` is customized to use regex by default, see [Rust regex syntax](https://docs.rs/regex/1.11.1/regex/#syntax).
--
--   Once the initial list is loaded, you refine it using fzf.
--   You can also configure fzf default behaviour, see https://github.com/nvim-telescope/telescope-fzf-native.nvim?tab=readme-ov-file#telescope-setup-and-configuration.
--   E.g. here fzf is customized to only show exact matches, the rest is noice.
--   For fzf syntax, see https://github.com/nvim-telescope/telescope-fzf-native.nvim?tab=readme-ov-file#telescope-fzf-nativenvim.
--
--   For default Telescope shortcuts see https://github.com/nvim-telescope/telescope.nvim?tab=readme-ov-file#default-mappings).
--   From within Telescope, use `<c-/>` (insert mode) or `?` (normal mode) to show keybindings.
--
--   Trouble integration can be really useful.
--   E.g. Use `grep_string` of `live_grep` to obtain a list of files with some specific text in them, refine the list with fzf, then maybe even mark only specific files with <Tab> and then export the list to Trouble.
--
--   For LSP and diagnostics see Trouble.
--
