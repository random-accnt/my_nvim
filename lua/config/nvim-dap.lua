require('dap-go').setup {

}

local dap, dapUI = require('dap'), require('dapui')
-- open/close UI with debugger
dap.listeners.after.event_initialized['dapui_config'] = function()
	dapUI.open()
end

dap.listeners.before.event_terminated['dapui_config'] = function()
	dapUI.close()
end

dap.listeners.before.event_exited['dapui_config'] = function()
	dapUI.close()
end

-- icons
vim.fn.sign_define('DapBreakpoint', { text = 'Br', texthl = '', linehl = '', numhl = '' })
vim.fn.sign_define('DapStopped', { text = '▶️', texthl = '', linehl = '', numhl = '' })

require('dapui').setup()
