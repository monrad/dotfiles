return {
	"andythigpen/nvim-coverage",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	keys = {
		{
			"<leader>vl",
			function()
				require("coverage").load(true)
			end,
			desc = "co[v]erage [l]oad",
		},
		{
			"<leader>vc",
			function()
				require("coverage").clear()
			end,
			desc = "co[v]erage [c]lear",
		},
		{
			"<leader>vw",
			function()
				require("coverage").show()
			end,
			desc = "co[v]erage sho[w]",
		},
		{
			"<leader>vh",
			function()
				require("coverage").hide()
			end,
			desc = "co[v]erage [h]ide",
		},
		{
			"<leader>vt",
			function()
				require("coverage").toggle()
			end,
			desc = "co[v]erage [t]oggle",
		},
		{
			"<leader>vs",
			function()
				require("coverage").summary()
			end,
			desc = "co[v]erage [s]ummary",
		},
	},
	opts = {},
}
