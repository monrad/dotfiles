return {
	"olimorris/codecompanion.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
	},
	opts = {
		log_level = debug,
		extensions = {
			mcphub = {
				callback = "mcphub.extensions.codecompanion",
				opts = {
					make_vars = true,
					make_slash_commands = true,
					show_result_in_chat = true,
				},
			},
		},
	},
	keys = {
		{
			"<leader>ac",
			function()
				require("codecompanion").toggle()
			end,
			desc = "CodeCompanion - Toogle Chat",
		},
	},
}
