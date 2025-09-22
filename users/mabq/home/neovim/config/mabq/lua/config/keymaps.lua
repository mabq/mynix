-- Without modifier key --

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Clear search hightlight' })

vim.keymap.set('n', 'J', 'mzJ`z', { desc = 'Join line (cursor in place)' })
-- vim.keymap.set('n', 'n', 'nzzzv', { desc = 'Next match (centered)' })
-- vim.keymap.set('n', 'N', 'Nzzzv', { desc = 'Previous match (centered)' })

vim.keymap.set('n', '<down>', '<C-e>', { desc = 'Scroll down (keep current line)' })
vim.keymap.set('n', '<up>', '<C-y>', { desc = 'Scroll up (keep current line)' })

vim.keymap.set('v', '<', '<gv', { desc = 'Decrease indentation (keep selection)' })
vim.keymap.set('v', '>', '>gv', { desc = 'Increase indentation (keep selection)' })

vim.keymap.set('v', 'J', ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = 'Move line down' })
vim.keymap.set('v', 'K', ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = 'Move line up' })

-- vim.keymap.set('n', 'Q', '<nop>', { desc = 'Disable Q default behavior' })

-- vim.keymap.set('c', '<down>', function() if vim.fn.pumvisible() == 1 then return '<c-n>' end return '<down>' end, { expr = true, desc = 'Select next menu item' })
-- vim.keymap.set('c', '<up>', function() if vim.fn.pumvisible() == 1 then return '<c-p>' end return '<up>' end, { expr = true, desc = 'Select previous menu item' })

-- Ctrl --

vim.keymap.set('n', '<C-s>', ':silent !tmux neww $HOME/.config/tmux/scripts/tmux-sessionizer.sh<CR>', { desc = 'Run tmux-sessionizer' })

vim.keymap.set('n', '<C-Left>', ':vertical resize -4<CR>', { desc = 'Decrease window width' })
vim.keymap.set('n', '<C-Right>', ':vertical resize +4<CR>', { desc = 'Increase window width' })
vim.keymap.set('n', '<C-Down>', ':resize -4<CR>', { desc = 'Decrease window height' })
vim.keymap.set('n', '<C-Up>', ':resize +4<CR>', { desc = 'Increase window height' })

vim.keymap.set('n', '<C-n>', '<cmd>cnext<CR>', { desc = 'Quickfix next' })
vim.keymap.set('n', '<C-p>', '<cmd>cprev<CR>', { desc = 'Quickfix previous' })

-- Leader --

vim.keymap.set('x', '<leader>p', [["_dP]], { desc = 'Paste without yanking' })
vim.keymap.set({ 'n', 'v' }, '<leader>y', [["+y]], { desc = 'Yank to clipboard' })
vim.keymap.set({ 'n', 'v' }, '<leader>d', [["_d]], { desc = 'Delete withou yanking' })

vim.keymap.set('n', '<leader>S', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]]) -- remane all instances of word under cursor

vim.keymap.set('n', '<leader>X', '<cmd>!chmod +x %<CR>', { silent = true }) -- make the current file executable

vim.keymap.set('n', '<leader><leader>X', '<cmd>source %<CR>', { desc = 'Source file' }) -- refresh lua configurations

-- Notes:
--   `:Telescope keymaps`         - list all keymaps
--   `:[verbose] map {keybind}`   - check specific keymap
--   `:h lua-guide-mappings`      - how to set keymaps
--   `:h map-modes`               - check modes table
