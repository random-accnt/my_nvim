local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

opts = {}
plugins = {
	-- colorscheme
	"tanvirtin/monokai.nvim",

	-- completion
	{
		"VonHeikemen/lsp-zero.nvim",
		branch = "v2.x",
		requires = {
			-- LSP Support
			{ "neovim/nvim-lspconfig" },    -- Required
			{ "williamboman/mason.nvim" },  -- Optional
			{ "williamboman/mason-lspconfig.nvim" }, -- Optional

			-- Autocompletion
			--{ "hrsh7th/nvim-cmp",                 config = [[require('config.nvim-cmp')]] }, -- Required
			{ "hrsh7th/cmp-nvim-lsp" }, -- Required
			--{ "L3MON4D3/LuaSnip" }, -- Required
		},
	},
	{ "williamboman/mason.nvim" },
	{ "williamboman/mason-lspconfig.nvim" },
	{ "neovim/nvim-lspconfig" },
	{
		"L3MON4D3/LuaSnip",
	},
	{
		"hrsh7th/nvim-cmp",
	},
	{ "hrsh7th/cmp-nvim-lsp", after = "nvim-cmp" },
	{ "hrsh7th/cmp-buffer",   after = "nvim-cmp" }, -- buffer auto-completion
	{ "hrsh7th/cmp-path",     after = "nvim-cmp" }, -- path auto-completion
	{ "hrsh7th/cmp-cmdline",  after = "nvim-cmp" }, -- cmdline auto-completion
	"saadparwaiz1/cmp_luasnip",
	{ "rafamadriz/friendly-snippets" },

	-- telescope
	{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.3",
		-- or                            , branch = '0.1.x',
		requires = { { "nvim-lua/plenary.nvim" } },
	},

	-- terminal
	{ "akinsho/toggleterm.nvim" },

	-- markdown
	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		build = "cd app && yarn install",
		init = function()
			vim.g.mkdp_filetypes = { "markdown" }
		end,
		ft = { "markdown" },
	},
	{
		"jakewvincent/mkdnflow.nvim",
		--- rocks = 'luautf8', -- Ensures optional luautf8 dependency is installed (hererocks install fails)
		config = function()
			require("mkdnflow").setup({
				mappings = {
					MkdnEnter = { { "i", "n", "v" }, "<CR>" },
					MkdnTableNewRowBelow = { "n", "<leader>ar" },
					MkdnTableNewRowAbove = { "n", "<leader>aR" },
					MkdnTableNewColAfter = { "n", "<leader>ac" },
					MkdnTableNewColBefore = { "n", "<leader>aC" },
				},
				links = {
					transform_explicit = function(text)
						text = text:gsub(" ", "-")
						text = text:lower()
						return text
					end,
				},
			})
		end,
	},
	{ "ekickx/clipboard-image.nvim" },

	-- debug
	{ "mfussenegger/nvim-dap" },
	{ "leoluz/nvim-dap-go" },
	{ "rcarriga/nvim-dap-ui",       requires = { "mfussenegger/nvim-dap" } },

	-- github
	{
		"topaxi/gh-actions.nvim",
		cmd = "GhActions",
		keys = {
			{ "<leader>gh", "<cmd>GhActions<cr>", desc = "Open Github Actions" },
		},
		-- optional, you can also install and use `yq` instead. build = 'make',
		dependencies = { "nvim-lua/plenary.nvim", "MunifTanjim/nui.nvim" },
		opts = {},
		config = function(_, opts)
			require("gh-actions").setup(opts)
		end,
	},

	-- other
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
	},
	{
		"windwp/nvim-autopairs",
		config = function()
			require("nvim-autopairs").setup({})
		end,
	},
	{ "elkowar/yuck.vim" },
	{
		"smoka7/hop.nvim",
		--tag = '*', -- optional but strongly recommended
	},

	{ "lervag/vimtex" },
	{
		"https://gitlab.com/itaranto/plantuml.nvim",
		--tag = '*'
	},
	{
		"cuducos/yaml.nvim",
		ft = { "yaml" }, -- optional
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-telescope/telescope.nvim", -- optional
		},
	},
	{
		"stevearc/conform.nvim",
		opts = {},
	},
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		init = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300
		end,
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
		},
	},
	{ "tyru/open-browser.vim" },
	{ "weirongxu/plantuml-previewer.vim" },
	{
		"ray-x/lsp_signature.nvim",
		event = "VeryLazy",
		opts = {},
		config = function(_, opts)
			require("lsp_signature").setup(opts)
		end,
	},
	{
		"gaoDean/autolist.nvim",
		ft = {
			"markdown",
			"text",
			"tex",
			"plaintex",
			"norg",
		},
		config = function()
			require("autolist").setup()

			vim.keymap.set("i", "<tab>", "<cmd>AutolistTab<cr>")
		end,
	},
}

require("lazy").setup(plugins, opts)
