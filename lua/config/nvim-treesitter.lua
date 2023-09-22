require 'nvim-treesitter.configs'.setup {
	ensure_installed = { "python", "markdown", "go", "lua" },
	auto_install = true,
	highlight = {
		enable = true,
	},
}
