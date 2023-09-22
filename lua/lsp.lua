require('lsp-zero')
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

-- local capabilities = vim.lsp.protocol.make_client_capabilities()
-- capabilities.textDocument.completion.completionItem.snippetSupport = true


-- LSP
local utils = require('utils')
local fn = vim.fn

local lsp = require('lsp-zero').preset({})
lsp.on_attach(
	function(client, bufnr)
		-- :h lsp-zero-keybindings for info
		lsp.default_keymaps({ buffer = bufnr })
	end
)

-- formatting
lsp.format_on_save({
	format_opts = {
		async = false,
		timeout_ms = 10000,
	},
	servers = {
		['lua_ls'] = { 'lua' },
		['gopls'] = { 'go' },
		['pylsp'] = { 'python' },
		['bashls'] = { 'bash' },
		['clangd'] = { 'c', 'cpp', 'objc', 'objcpp', 'cuda', 'proto' }
	}
})

-- Lua
if utils.executable('lua-language-server') then
	lspconfig.lua_ls.setup(lsp.nvim_lua_ls())
end

-- Python
if utils.executable('pylsp') then
	lspconfig.pylsp.setup {
	}
end

-- Go
if utils.executable('gopls') then
	lspconfig.gopls.setup({
		cmd = { 'gopls' },
	})
end

-- bash
if utils.executable('bashls') then
	lspconfig.bashls.setup {
	}
end

-- C++
if utils.executable('clangd') then
	lspconfig.clangd.setup {}
end

lsp.setup()
