local ls = require("luasnip")

ls.config.set_config({
	history = true,
	updateevents = "TextChanged,TextChangedI",
})
--
-- Function to list all the snippet files in the snippets directory
local function list_snippet_files()
	local snippet_files = vim.fn.globpath(vim.fn.stdpath("config") .. "/snippets", "*", true, true)
	local filetypes = {}

	for _, file in ipairs(snippet_files) do
		local filetype = vim.fn.fnamemodify(file, ":t:r") -- Extract filetype from filename
		table.insert(filetypes, filetype)
	end

	return filetypes
end

-- all filetypes from snippets/*
local excluded_filetypes = list_snippet_files()

local function is_excluded_filetype(filetype)
	return vim.tbl_contains(excluded_filetypes, filetype)
end

-- load snippets (my for some filetypes else vscode)
function load_snippets()
	local current_filetype = vim.bo.filetype
	if not is_excluded_filetype(current_filetype) then
		require("luasnip.loaders.from_vscode").lazy_load()
	else
		require("luasnip.loaders.from_vscode").lazy_load()
	end
end

-- Load snippets based on filetype
vim.cmd([[
augroup LoadSnippets
    autocmd!
    autocmd FileType * lua load_snippets()
augroup END
]])
