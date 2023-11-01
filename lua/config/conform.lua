require("conform").formatters.isort = {
	prepend_args = { "-l", "79" },
}

require("conform").formatters.black = {
	prepend_args = { "--line-length", "79", "--experimental-string-processing" },
}

require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		-- Conform will run multiple formatters sequentially
		python = { "isort", "black" },
		go = { "gci", "goimports", "gofmt" },
		-- Use a sub-list to run only the first available formatter
		javascript = { "prettier" },
		yaml = { { "yamlfmt", "prettier" } },
		yml = { { "yamlfmt", "prettier" } },
	},
	format_on_save = {
		-- These options will be passed to conform.format()
		timeout_ms = 500,
		lsp_fallback = true,
	},
})
