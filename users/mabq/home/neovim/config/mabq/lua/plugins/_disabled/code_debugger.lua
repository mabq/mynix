-- Same concept as LSP - debuggers are external tools that communicate with
-- Neovim via a protocol. Unlike LPS, Neovim does not already include the
-- dap protocol client.

return {
  'mfussenegger/nvim-dap', -- dap protocol for Neovim
  dependencies = {
    {
      'rcarriga/nvim-dap-ui', -- ui (windows and buttons)
      dependencies = {
        'nvim-neotest/nvim-nio',
        'folke/lazydev.nvim',
      },
    },
    'theHamsta/nvim-dap-virtual-text',
    -- pre-configurations
    'mfussenegger/nvim-dap-python',
    -- install debugger tools with pacman (see ansible):
    --   python: `python-debugpy`
  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'
    local dap_python = require 'dap-python'

    require('dapui').setup()
    -- require('nvim-dap-virtual-text').setup {
    --     commented = true, -- show virtual text alongside comment
    -- }

    require('dap-python').setup 'python3'

    local opts = { noremap = true, silent = true }

    vim.keymap.set('n', '<leader>db', dap.toggle_breakpoint, opts)
    vim.keymap.set('n', '<leader>dq', dap.terminate, opts)
    vim.keymap.set('n', '<F8>', dap.step_back, opts)
    vim.keymap.set('n', '<F9>', dap.continue, opts)
    vim.keymap.set('n', '<F10>', dap.step_into, opts)
    vim.keymap.set('n', 'S-<F10>', dap.step_over, opts)
    vim.keymap.set('n', 'S-<F8>', dap.step_out, opts)
    vim.keymap.set('n', '<F13>', dap.restart, opts)
    -- vim.keymap.set('n', '<leader>?', function()
    --     -- eval under cursor
    --     dapui.eval(nil, { enter = true })
    -- end, opts)

    -- automatically open debugger windows
    dap.listeners.before.attach.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.launch.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated.dapui_config = function()
      dapui.close()
    end
    dap.listeners.before.event_exited.dapui_config = function()
      dapui.close()
    end
  end,
}
