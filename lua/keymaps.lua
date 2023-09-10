local opts = {
	noremap = true,
}
local keymap = vim.keymap

vim.g.mapleader = ' '

--
-- NORMAL M.
--

keymap.set('n', '<leader>q', '<cmd>x<cr>', opts)
keymap.set('n', '<leader>Q', '<cmd>qa!<cr>', opts)
keymap.set('n', '<leader>w', '<cmd>update<cr>', opts)

-- Ctrl+h/j/k/l to switch window
keymap.set('n', '<C-h>', '<C-w>h', opts)
keymap.set('n', '<C-j>', '<C-w>j', opts)
keymap.set('n', '<C-k>', '<C-w>k', opts)
keymap.set('n', '<C-l>', '<C-w>l', opts)

-- Ctrl+arrows to resize
keymap.set('n', '<C-Up>', ':resize -2<CR>', opts)
keymap.set('n', '<C-Down>', ':resize +2<CR>', opts)
keymap.set('n', '<C-Left>', ':vertical resize -2<CR>', opts)
keymap.set('n', '<C-Right>', ':vertical resize -2<CR>', opts)

-- Ctrl+w+h/j/k/l open window
keymap.set('n', '<C-w><C-h>', ':lefta vs<CR>', opts)
keymap.set('n', '<C-w><C-j>', ':bel sp<CR>', opts)
keymap.set('n', '<C-w><C-k>', ':to sp<CR>', opts)
keymap.set('n', '<C-w><C-l>', ':rightb vs<CR>', opts)

--
-- VISUAL M.
--
keymap.set('v', '<', '<gv', opts)
keymap.set('v', '>', '>gv', opts)

--
-- TERMINAL M.
--
-- TODO: move class and toggle function to other file
local Terminal = require('toggleterm.terminal').Terminal
local floating_term = Terminal:new({
	direction = 'float',
	on_open = function(term)
		vim.cmd('startinsert!')
	end,
	on_close = function(term)
		vim.cmd('startinsert!')
	end,
})

function _toggle_floating()
	floating_term:toggle()
end

function _G.set_terminal_keymaps()
	local term_opts = { buffer = 0 }
	keymap.set('t', '<esc>', [[<C-\><C-n>:lua _toggle_floating()<CR>]], term_opts)
end

vim.cmd('autocmd! TermOpen term://*toggleterm#* lua set_terminal_keymaps()')

keymap.set('n', '<leader>t', '<cmd>lua _toggle_floating()<CR>', opts)
