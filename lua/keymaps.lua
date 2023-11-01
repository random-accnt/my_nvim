local opts = {
	noremap = true,
}
local keymap = vim.keymap
local wk = require("which-key")

vim.g.mapleader = " "

--
-- NORMAL M.
--

keymap.set("n", "<leader>q", "<cmd>x<cr>", opts)
keymap.set("n", "<leader>Q", "<cmd>qa!<cr>", opts)
keymap.set("n", "<leader>w", "<cmd>update<cr>", opts)

-- Ctrl+h/j/k/l to switch window
keymap.set("n", "<C-h>", "<C-w>h", opts)
keymap.set("n", "<C-j>", "<C-w>j", opts)
keymap.set("n", "<C-k>", "<C-w>k", opts)
keymap.set("n", "<C-l>", "<C-w>l", opts)

-- Ctrl+arrows to resize
keymap.set("n", "<C-Up>", ":resize -2<CR>", opts)
keymap.set("n", "<C-Down>", ":resize +2<CR>", opts)
keymap.set("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap.set("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Ctrl+w+h/j/k/l open window
wk.register({
	["<C-w>"] = {
		name = "Window",
		["<C-h>"] = { ":lefta vs <cr>", "Create left" },
		["<C-j>"] = { ":bel sp <cr>", "Create bellow" },
		["<C-k>"] = { ":to sp <cr>", "Create above" },
		["<C-l>"] = { ":rightb vs <cr>", "Create right" },
	},
})

-- hop: reimplement some motion keys
local hop = require("hop")
local directions = require("hop.hint").HintDirection

keymap.set("", "f", function()
	hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = false })
end, { remap = true })

keymap.set("", "F", function()
	hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = false })
end, { remap = true })

-- debugging
dap = require("dap")
keymap.set("n", "<F5>", dap.continue)
keymap.set("n", "<F10>", dap.step_over)
keymap.set("n", "<F11>", dap.step_into)
keymap.set("n", "<F12>", dap.step_out)

wk.register({
	["<leader>"] = {
		b = { "<cmd> lua dap.toggle_breakpoint() <cr>", "Toggle breakpoint" },
	},
})

keymap.set("", "<C-w>", function()
	hop.hint_words({ direction = directions.AFTER_CURSOR })
end, { remap = true })

-- telescope
builtin = require("telescope.builtin")
local dropdown = require("telescope.themes").get_dropdown()

wk.register({
	["<leader>f"] = {
		name = "Telescope",
		f = { "<cmd>lua  builtin.find_files(dropdown) <cr>", "Find file" },
		g = { "<cmd>Telescope live_grep<cr>", "Grep" },
		b = { "<cmd>Telescope buffers<cr>", "Find buffer" },
		h = { "<cmd>Telescope help_tags<cr>", "Find help" },
		r = { "<cmd>Telescope lsp_references<cr>", "Find references" },
		s = { "<cmd>Telescope lsp_document_symbols<cr>", "Find symbol" },
	},
})

wk.register({
	["<leader>d"] = {
		name = "Diagnostic",
		n = { "<cmd>lua vim.diagnostic.goto_next() <cr>", "Next warning" },
		N = { "<cmd>lua vim.diagnostic.goto_prev() <cr>", "Previous warning" },
		d = { "<cmd>lua vim.diagnostic.open_float() <cr>", "Previous warning" },
	},
})

-- other
vim.keymap.set({ "n" }, "<C-K>", function()
	require("lsp_signature").toggle_float_win()
end, { silent = true, noremap = true, desc = "toggle signature" })

--
-- VISUAL M.
--
keymap.set("v", "<", "<gv", opts)
keymap.set("v", ">", ">gv", opts)

--
-- TERMINAL M.
--
-- TODO: move class and toggle function to other file
local Terminal = require("toggleterm.terminal").Terminal
local floating_term = Terminal:new({
	direction = "float",
	on_open = function(term)
		vim.cmd("startinsert!")
	end,
	on_close = function(term)
		vim.cmd("startinsert!")
	end,
})

function _toggle_floating()
	floating_term:toggle()
end

function _G.set_terminal_keymaps()
	local term_opts = { buffer = 0 }
	keymap.set("t", "<esc>", [[<C-\><C-n>:lua _toggle_floating()<CR>]], term_opts)
end

vim.cmd("autocmd! TermOpen term://*toggleterm#* lua set_terminal_keymaps()")

wk.register({
	["<leader>"] = {
		t = { "<cmd>lua _toggle_floating()<CR>", "Toggle terminal" },
	},
})

--
-- INSERT M.
--

--
-- CUSTOM
--
-- Printing missing chars
function Missing_letter(text)
	local pos = vim.api.nvim_win_get_cursor(0)[2] + 1
	local line = vim.api.nvim_get_current_line()
	local nline = line:sub(0, pos) .. text .. line:sub(pos + 1)
	vim.api.nvim_set_current_line(nline)
	-- TODO: how to right
	vim.cmd(":normal l")
end

keymap.set("n", "z", ':lua Missing_letter("y")<CR>', opts)
keymap.set("n", "Z", ':lua Missing_letter("Y")<CR>', opts)

-- use Tab to indent list
vim.api.nvim_exec(
	[[
    autocmd Filetype markdown,text,gitcommit setlocal expandtab tabstop=4 softtabstop=4 shiftwidth=4
    autocmd Filetype markdown,text,gitcommit inoremap <Tab> <C-R>=luaeval("InsertTabWrapper()")<CR>
]],
	false
)

function _G.InsertTabWrapper()
	local col = vim.fn.col(".") - 1
	if vim.fn.getline(".")[col]:match("^s*$") then
		return vim.api.nvim_replace_termcodes("<Tab>", true, true, true)
	else
		return vim.api.nvim_replace_termcodes("<C-t>", true, true, true)
	end
end
