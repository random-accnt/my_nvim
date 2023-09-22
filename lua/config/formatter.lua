local util = require 'formatter.util'

require('formatter').setup {
	filetype = {
		cpp = {
			require 'formatter.filetypes.cpp'.clangformat,
			function()
				return {
					exe = 'clang-format',
					args = {
						'--style=file',
					},
				}
			end
		}
	}
}
