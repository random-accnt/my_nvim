local has_words_before = function()
	unpack = unpack or table.unpack
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))

	return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

require("luasnip.loaders.from_vscode").lazy_load()
local luasnip = require('luasnip')
local cmp = require('cmp')

cmp.setup({
	preselect = 'item',
	snippet = {
		expand = function(args)
			luasnip.lsp_expend(args.body)
		end,
	},

	mapping = cmp.mapping.preset.insert({
		-- confirm
		['<CR>'] = cmp.mapping.confirm({ select = true }),
		-- tab
		["<Tab>"] = cmp.mapping(function(fallback)
			-- Hint: if the completion menu is visible select next one
			if cmp.visible() then
				cmp.select_next_item()
			elseif has_words_before() then
				-- if in markdown don't complete
				if vim.bo.filetype == 'markdown' then
					fallback()
				else
					cmp.complete()
				end
			else
				fallback()
			end
		end, { "i", "s" }), -- i - insert mode; s - select mode
		["<S-Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { "i", "s" }),
	}),

	formatting = {
		fields = { 'abbr', 'menu' },
		format = function(entry, vim_item)
			vim_item.menu = ({
				nvim_lsp = '[Lsp]',
				luasnip = '[Luasnip]',
				buffer = '[File]',
				path = '[Path]',
			})[entry.source.name]
			return vim_item
		end,
	},

	sources = cmp.config.sources({
		{ name = 'nvim_lsp' },
		{ name = 'luasnip' },
		{ name = 'buffer' },
		{ name = 'path' },
	})
})
