local ensure_packer = function()
	local fn = vim.fn
	local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
	if fn.empty(fn.glob(install_path)) > 0 then
		fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
		vim.cmd [[packadd packer.nvim]]
		return true
	end
	return false
end
local packer_bootstrap = ensure_packer()

-- Reload configurations if we modify plugins.lua
-- Hint
--     <afile> - replaced with the filename of the buffer being manipulated
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])


-- Install plugins here - `use ...`
-- Packer.nvim hints
--     after = string or list,           -- Specifies plugins to load before this plugin. See "sequencing" below
--     config = string or function,      -- Specifies code to run after this plugin is loaded
--     requires = string or list,        -- Specifies plugin dependencies. See "dependencies".
--     ft = string or list,              -- Specifies filetypes which load this plugin.
--     run = string, function, or table, -- Specify operations to be run after successful installs/updates of a plugin
return require('packer').startup(function(use)
	-- Packer can manage itself
	use 'wbthomason/packer.nvim'

	-- colorscheme
	use 'tanvirtin/monokai.nvim'

	-- completion
	use {
		'VonHeikemen/lsp-zero.nvim',
		branch = 'v2.x',
		requires = {
			-- LSP Support
			{ 'neovim/nvim-lspconfig' },    -- Required
			{ 'williamboman/mason.nvim' },  -- Optional
			{ 'williamboman/mason-lspconfig.nvim' }, -- Optional

			-- Autocompletion
			{ 'hrsh7th/nvim-cmp' }, -- Required
			{ 'hrsh7th/cmp-nvim-lsp' }, -- Required
			{ 'L3MON4D3/LuaSnip' }, -- Required
		}
	}
	use { 'williamboman/mason.nvim' }
	use { 'williamboman/mason-lspconfig.nvim' }
	use { 'neovim/nvim-lspconfig' }
	use { 'hrsh7th/nvim-cmp', config = [[require('config.nvim-cmp')]] }
	use { 'hrsh7th/cmp-nvim-lsp', after = 'nvim-cmp' }
	use { 'hrsh7th/cmp-buffer', after = 'nvim-cmp' } -- buffer auto-completion
	use { 'hrsh7th/cmp-path', after = 'nvim-cmp' } -- path auto-completion
	use { 'hrsh7th/cmp-cmdline', after = 'nvim-cmp' } -- cmdline auto-completion
	use 'saadparwaiz1/cmp_luasnip'
	use { "rafamadriz/friendly-snippets" }

	-- telescope
	use { 'nvim-telescope/telescope-fzf-native.nvim', run =
	'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' }
	use {
		'nvim-telescope/telescope.nvim', tag = '0.1.3',
		-- or                            , branch = '0.1.x',
		requires = { { 'nvim-lua/plenary.nvim' } }
	}

	-- terminal
	use { 'akinsho/toggleterm.nvim' }

	-- markdown
	use({
		"iamcco/markdown-preview.nvim",
		run = function() vim.fn["mkdp#util#install"]() end,
	})
	use({
		'jakewvincent/mkdnflow.nvim',
		--- rocks = 'luautf8', -- Ensures optional luautf8 dependency is installed (hererocks install fails)
		config = function()
			require("mkdnflow").setup({
				mappings = {
					MkdnEnter = { { 'i', 'n', 'v' }, '<CR>' },
					MkdnTableNewRowBelow = { 'n', '<leader>ar' },
					MkdnTableNewRowAbove = { 'n', '<leader>aR' },
					MkdnTableNewColAfter = { 'n', '<leader>ac' },
					MkdnTableNewColBefore = { 'n', '<leader>aC' },
				},
				links = {
					transform_explicit = function(text)
						text = text:gsub(" ", "-")
						text = text:lower()
						return (text)
					end
				}
			})
		end
	})
	use { 'ekickx/clipboard-image.nvim' }

	-- debug
	use { 'mfussenegger/nvim-dap' }
	use { 'leoluz/nvim-dap-go' }
	use { "rcarriga/nvim-dap-ui", requires = { "mfussenegger/nvim-dap" } }

	-- other
	use {
		'nvim-treesitter/nvim-treesitter',
		run = ':TSUpdate'
	}
	use {
		"windwp/nvim-autopairs",
		config = function() require("nvim-autopairs").setup {} end
	}
	use { 'elkowar/yuck.vim' }
	use {
		'smoka7/hop.nvim',
		tag = '*', -- optional but strongly recommended
	}
	use { 'lervag/vimtex' }
	use { 'https://gitlab.com/itaranto/plantuml.nvim', tag = '*' }

	-- Automatically set up your configuration after cloning packer.nvim
	-- Put this at the end after all plugins
	if packer_bootstrap then
		require('packer').sync()
	end
end)
