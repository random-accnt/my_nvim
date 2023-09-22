-- save when navigating away from buffer (follow link)
vim.api.nvim_create_autocmd("FileType", { pattern = "markdown", command = "set awa" })

-- https://github.com/jakewvincent/mkdnflow.nvim#-commands-and-default-mappings
require('mkdnflow').setup({
	mappings = {
		MkdnEnter = { { 'i', 'n', 'v' }, '<CR>' },
		MkdnTableNextCell = { 'i', '<C-Tab>' }
	}
})
