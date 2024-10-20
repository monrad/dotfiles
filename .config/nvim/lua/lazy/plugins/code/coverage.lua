return {
	"andythigpen/nvim-coverage",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	keys = {
		{ "<leader>cc", "", desc = "+coverage" },
		{
			"<leader>ccl",
			function()
				require("coverage").load(true)
			end,
			desc = "Load",
		},
		{
			"<leader>ccc",
			function()
				require("coverage").clear()
			end,
			desc = "Clear",
		},
		{
			"<leader>ccw",
			function()
				require("coverage").show()
			end,
			desc = "Show",
		},
		{
			"<leader>cch",
			function()
				require("coverage").hide()
			end,
			desc = "Hide",
		},
		{
			"<leader>cct",
			function()
				require("coverage").toggle()
			end,
			desc = "Toggle",
		},
		{
			"<leader>ccs",
			function()
				require("coverage").summary()
			end,
			desc = "Summary",
		},
	},
	opts = {},
}
