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

--
-- VISUAL M.
--
keymap.set('v', '<', '<gv', opts)
keymap.set('v', '>', '>gv', opts)

