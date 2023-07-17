vim.g.mapleader = ' '

-- in 'normal' mode using 'leader'(space)+'w' execute 'save'
vim.keymap.set('n', '<leader>w', '<cmd>write<cr>')
vim.keymap.set('n', '<leader>q', '<cmd>quit<cr>')
-- copy, paste from system clipboard
vim.keymap.set({'n', 'x'}, 'cp', '"+y"')
vim.keymap.set({'n', 'x'}, 'cv', '"+p"')
-- deleting using 'x' doesn't affect register
vim.keymap.set({'n', 'x'}, 'x', '"_x"')
-- select all in buffer (goto top, select line, goto bot)
vim.keymap.set('n', '<leader>a', ':keepjumps normal! ggVG<cr>')

-- some LSP features added when LS attached to buffer
vim.api.nvim_create_autocmd('LspAttach', {
	desc = 'LSP stuff',
	callback = function()
		local bufmap = function(mode, lhs, rhs)
			local opts = {buffer = true}
			vim.keymap.set(mode, lhs, rhs, opts)
		end
	
	-- display info
	bufmap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>')
	-- goto definition
	bufmap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>')
	-- goto declaration
	bufmap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>')
	-- list implementations
	bufmap('n', 'gi', '<cmd>lua vim.lsp.buf.implementaion()<cr>')
	-- list implementations
	bufmap('n', 'gi', '<cmd>lua vim.lsp.buf.implementaion()<cr>')
	-- refactor name
	bufmap('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>')
	end
})
