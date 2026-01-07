return {
	"nvim-treesitter/nvim-treesitter-context",
	event = "VeryLazy",
	dependencies = { "nvim-treesitter/nvim-treesitter" },
	opts = {
		max_lines = 3,
		min_window_height = 20,
	},
	keys = {
		{
			"[C",
			function()
				require("treesitter-context").go_to_context()
			end,
			desc = "Go to context",
		},
	},
}
