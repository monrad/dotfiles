-- Setup Lazy plugins
require("lazy").setup({
	-- load plugins
	-- ui plugins
	require("lazy.plugins.ui.grug-far"),
	require("lazy.plugins.ui.inc-rename"),
	require("lazy.plugins.ui.indent-blanklines"),
	require("lazy.plugins.ui.lualine"),
	require("lazy.plugins.ui.neo-tree"),
	require("lazy.plugins.ui.noice"),
	require("lazy.plugins.ui.oil"),
	require("lazy.plugins.ui.todo-comments"),
	require("lazy.plugins.ui.tokyonight"),
	require("lazy.plugins.ui.trouble"),
	-- base plugins
	require("lazy.plugins.base.arrow"),
	require("lazy.plugins.base.telescope"),
	require("lazy.plugins.base.undotree"),
	require("lazy.plugins.base.vim-sleuth"),
	require("lazy.plugins.base.which-key"),
	-- code plugins
	require("lazy.plugins.code.ansible"),
	require("lazy.plugins.code.autocompletion"),
	require("lazy.plugins.code.autopairs"),
	require("lazy.plugins.code.conform"),
	require("lazy.plugins.code.coverage"),
	require("lazy.plugins.code.dap"),
	require("lazy.plugins.code.git"),
	require("lazy.plugins.code.go"),
	require("lazy.plugins.code.lsp"),
	require("lazy.plugins.code.lua"),
	require("lazy.plugins.code.markdown"),
	require("lazy.plugins.code.neotest"),
	require("lazy.plugins.code.nvim-lint"),
	require("lazy.plugins.code.python"),
	require("lazy.plugins.code.treesitter"),
	require("lazy.plugins.code.yaml"),

	ui = {
		-- If you have a Nerd Font, set icons to an empty table which will use the
		-- default lazy.nvim defined Nerd Font icons otherwise define a unicode icons table
		icons = vim.g.have_nerd_font and {} or {
			cmd = "⌘",
			config = "🛠",
			event = "📅",
			ft = "📂",
			init = "⚙",
			keys = "🗝",
			plugin = "🔌",
			runtime = "💻",
			require = "🌙",
			source = "📄",
			start = "🚀",
			task = "📌",
			lazy = "💤 ",
		},
	},
})
