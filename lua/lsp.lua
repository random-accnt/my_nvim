require("lsp-zero")
require("mason").setup({
	ui = {
		icons = {
			package_installed = "✓",
			package_pending = "➜",
			package_uninstalled = "✗",
		},
	},
})

require("mason-lspconfig").setup({
	-- list of lsp servers
	-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
	ensure_installed = { "pylsp", "gopls", "lua_ls", "bashls", "tsserver", "cssls", "yamlls", "marksman", "taplo",
		"ocamllsp" },
})

local lspconfig = require("lspconfig")

local opts = { noremap = true }
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts)

-- LSP
local utils = require("utils")
local fn = vim.fn

local lsp = require("lsp-zero").preset({})
lsp.on_attach(function(client, bufnr)
	-- :h lsp-zero-keybindings for info
	lsp.default_keymaps({ buffer = bufnr })
end)

-- formatting
lsp.format_on_save({
	format_opts = {
		async = false,
		timeout_ms = 10000,
	},
	servers = {
		["lua_ls"] = { "lua" },
		["gopls"] = { "go" },
		["pylsp"] = { "python" },
		["bashls"] = { "bash" },
		["clangd"] = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
		["tsserver"] = {
			"javascript",
			"javascriptreact",
			"javascript.jsx",
			"typescript",
			"typescriptreact",
			"typescript.tsx",
		},
		["cssls"] = { "css", "scss", "less" },
		["yamlls"] = { "yml", "yaml" },
		["marksman"] = { "md" },
		["taplo"] = { "toml" },
		["ocamllsp"] = { "ocaml", "ocaml.menhir", "ocaml.interface", "ocaml.ocamllex", "reason", "dune" },
	},
})

-- capabilities.textDocument.completion.completionItem.snippetSupport = true
local capabilities = require("cmp_nvim_lsp").default_capabilities()


-- Lua
if utils.executable("lua-language-server") then
	lspconfig.lua_ls.setup({
		capabilities = capabilities,
		lsp.nvim_lua_ls(),
	})
end

-- Python
if utils.executable("pylsp") then
	lspconfig.pylsp.setup {
		capabilities = capabilities,
	}
end

-- Go
if utils.executable("gopls") then
	lspconfig.gopls.setup({
		capabilities = capabilities,
		cmd = { "gopls" },
	})
end

-- bash
if utils.executable("bashls") then
	lspconfig.bashls.setup({
		capabilities = capabilities,
	})
end

-- C++
if utils.executable("clangd") then
	lspconfig.clangd.setup({
		capabilities = capabilities,
	})
end

-- Typescript
if utils.executable("tsserver") then
	lspconfig.tsserver.setup({
		capabilities = capabilities,
	})
end

-- CSS
if utils.executable("cssls") then
	lspconfig.cssls.setup({
		capabilities = capabilities,
	})
end

-- Markdown
if utils.executable("marksman") then
	lspconfig.marksman.setup({
		capabilities = capabilities,
	})
end

-- YAML
if utils.executable("yamlls") then
	lspconfig.yamlls.setup({
		capabilities = capabilities,
		settings = {
			yaml = {
				schemas = {
					["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
				},
			},
			format = {
				enable = true,
			},
			validate = true,
			completion = true,
		},
	})
end

if utils.executable("taplo") then
	lspconfig.taplo.setup({
		capabilities = capabilities,
	})
end

-- ocaml
if utils.executable("ocamllsp") then
	lspconfig.ocamllsp.setup({

	})
end

lsp.setup()
