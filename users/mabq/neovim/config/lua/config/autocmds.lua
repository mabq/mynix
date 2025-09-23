local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

local mabqGroup = augroup('mabq', {})

autocmd('TextYankPost', {
  desc = 'Highlight when yanking',
  group = augroup('highlightYank', {}),
  callback = function()
    (vim.hl or vim.highlight).on_yank()
  end,
})

-- automatically remove all trailling spaces before saving
autocmd({ 'BufWritePre' }, {
  group = mabqGroup,
  pattern = '*',
  command = [[%s/\s\+$//e]],
})

-- close with `q`
autocmd('FileType', {
  group = mabqGroup,
  pattern = {
    'checkhealth',
    'help',
    'lspinfo',
    'qf', -- quickfix list
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.schedule(function()
      vim.keymap.set('n', 'q', function()
        vim.cmd 'close'
        pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
      end, {
        buffer = event.buf,
        silent = true,
        desc = 'Quit buffer',
      })
    end)
  end,
})

---- automatically wrap and check for spell in text filetypes
-- autocmd('FileType', {
--   group = mabqGroup,
--   pattern = { 'text', 'plaintex', 'typst', 'gitcommit', 'markdown' },
--   callback = function()
--     vim.opt_local.wrap = true
--     vim.opt_local.spell = true
--   end,
-- })

-- autocmd('BufEnter', {
--   group = mabqGroup,
--   callback = function()
--     if vim.bo.filetype == 'zig' then
--       vim.cmd.colorscheme 'tokyonight-night'
--     else
--       vim.cmd.colorscheme 'rose-pine-moon'
--     end
--   end,
-- })

---- go to last location on open
-- autocmd('BufReadPost', {
--   group = mabqGroup,
--   callback = function(event)
--     local exclude = { 'gitcommit' }
--     local buf = event.buf
--     if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].lazyvim_last_loc then
--       return
--     end
--     vim.b[buf].lazyvim_last_loc = true
--     local mark = vim.api.nvim_buf_get_mark(buf, '"')
--     local lcount = vim.api.nvim_buf_line_count(buf)
--     if mark[1] > 0 and mark[1] <= lcount then
--       pcall(vim.api.nvim_win_set_cursor, 0, mark)
--     end
--   end,
-- })

---- automatically create directory on save
-- autocmd({ 'BufWritePre' }, {
--   group = mabqGroup,
--   callback = function(event)
--     if event.match:match '^%w%w+:[\\/][\\/]' then
--       return
--     end
--     local file = vim.uv.fs_realpath(event.match) or event.match
--     vim.fn.mkdir(vim.fn.fnamemodify(file, ':p:h'), 'p')
--   end,
-- })

-- Notes:
--   [Autocmds explanation in the context of LSP](https://youtu.be/HL7b63Hrc8U?si=CBt_Hz8IXrJAgear&t=926)
--   `:h lua-guide-autocommands`
--   `:h events`
