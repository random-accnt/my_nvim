require('mason').setup({
		ui = {
				icons = {
						package_installed = "✓",
						package_pending = "➜",
						package_uninstalled = "✗"
				}
		}
})

require('mason-lspconfig').setup({
		-- list of lsp servers
		-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
		ensure_installed = { 'pylsp', 'gopls', 'lua_ls', 'bashls' }
})

local lspconfig = require('lspconfig')

local opts = { noremap = true }
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)


-- LSP
local utils = require('utils')
local fn = vim.fn

-- Lua
if utils.executable('lua-language-server') then
	lspconfig.lua_ls.setup {
		settings = {
			Lua = {
				diagnostics = {
					globals = { 'vim' },	--recognize 'vim' global in lua
				},
				workspace = {
					-- Make the server aware of Neovim runtime files,
					library = {
						fn.stdpath("data") .. "/lazy/emmylua-nvim",
						fn.stdpath("config"),
					},
					maxPreload = 2000,
					preloadFileSize = 50000,
				},
			},
		},
	}
end

-- Python
if utils.executable('pylsp') then
	lspconfig.pylsp.setup {
	}
end

-- Go
if utils.executable('gopls') then
	lspconfig.gopls.setup {
	}
end

-- bash
if utils.executable('bashls') then
	lspconfig.bashls.setup {
	}
end
