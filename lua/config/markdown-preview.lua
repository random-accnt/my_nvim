g = vim.g

g.mkdp_auto_start = 1
g.mkdp_auto_close = 1
g.mkdp_refresh_slow = 0 -- 1.. refresh on save, 0.. refresh on edit/move
g.mkdp_preview_options = {
	sync_scroll_type = 'relative',
}
g.mkdp_filetypes = { 'markdown' }
g.mkdp_theme = 'dark'
