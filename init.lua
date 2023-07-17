require('user.settings')
require('user.keymaps')

----------------------------PLUGIN-----------------------------------
local lazy = {}

function lazy.install(path)
	if not vim.loop.fs_stat(path) then
	    print('Installing lazy.nvim....')
	    vim.fn.system({
	      'git',
	      'clone',
	      '--filter=blob:none',
	      'https://github.com/folke/lazy.nvim.git',
	      '--branch=stable', -- latest stable release
	      path,
	    })
	end
end

function lazy.setup(plugins)
	lazy.install(lazy.path)
	vim.opt.rtp:prepend(lazy.path)
	require('lazy').setup(plugins, lazy.opts)
end

lazy.path = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
lazy.opts = {}

-- PLUGINS --
lazy.setup({
	{"sainnhe/sonokai"},
	{'nvim-lualine/lualine.nvim'},
	-- completion
	{'neovim/nvim-lspconfig'},
	{'hrsh7th/nvim-cmp'},
	{'hrsh7th/cmp-buffer'},
	{'hrsh7th/cmp-path'},
	{'hrsh7th/cmp-nvim-lsp'},
	{'saadparwaiz1/cmp_luasnip'},
	{'L3MON4D3/LuaSnip'},
	{'rafamadriz/friendly-snippets'},
})

--------------------------PLUGIN-CONF--------------------------------
vim.cmd [[colorscheme sonokai]]

require('lualine').setup({
	options = {
		icons_enabled = false,
		section_separators = '',
		component_separators = '',
	}
})

-- completion
local lspconfig = require('lspconfig')
local lsp_defaults = lspconfig.util.default_config

lsp_defaults.capabilities = vim.tbl_deep_extend(
	'force',
	lsp_defaults.capabilities,
	require('cmp_nvim_lsp').default_capabilities()
)

lspconfig.lua_ls.setup({
	single_file_support = true,
})

require('luasnip.loaders.from_vscode').lazy_load()
vim.opt.completeopt = {'menu', 'menuone', 'noselect'}

local cmp = require('cmp')
local luasnip = require('luasnip')
local select_opts = {behavior = cmp.SelectBehavior.Select}

cmp.setup({
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end
	},
	sources = {
		{name = 'path'},							-- filepaths
		{name = 'nvim_lsp', keyword_length = 1},	-- lang. server
		{name = 'buffer', keyword_length = 3},		-- words in buffer
		{name = 'luasnip', keyword_length = 2},		-- snippets
	},
	window = {
		documentation = cmp.config.window.bordered()
	},
	formatting = {
		fields = {'menu', 'abbr', 'kind'},
		format = function(entry, item)
			local icon = {
				nvim_lsp = 'L',
				luasnip = 'S',
				buffer = 'B',
				path = 'P',
			}
			item.menu = icon[entry.source.name]
			return item
		end,
	},
	mapping = {
		['<Up>'] = cmp.mapping.select_prev_item(select_opts),
		['<Down>'] = cmp.mapping.select_next_item(select_opts),

		['<C-u>'] = cmp.mapping.scroll_docs(-4)
		['<C-d>'] = cmp.mapping.scroll_docs(4)

		['<C-e>'] = cmp.mapping.abort()

		['<C-y>'] = cmp.mapping.confirm({select = true})
		['<CR>'] = cmp.mapping.confirm({select = false})

		-- auricomplete with Tab (in menu goto next, if empty insert Tab, if in word trigger completion menu)
		['Tab'] = cmp.mapping(function(fallback)
			local col = vim.fn.col('.') -1

			if cmp.visible() then
				cmp.select_next_item(select_opts)
			elseif col == 0 of vim.fn.getline('.'):sub(col, col):match('%s') then
				fallback()
			else
				cmp.complete()
			end
		end, {'i', 's'}),
	}

})

