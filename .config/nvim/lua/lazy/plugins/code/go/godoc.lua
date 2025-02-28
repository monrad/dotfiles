return {
	"fredrikaverpil/godoc.nvim",
	version = "*",
	dependencies = {
		{ "folke/snacks.nvim" },
		{
			"nvim-treesitter/nvim-treesitter",
			opts = {
				ensure_installed = { "go" },
			},
		},
	},
	build = "go install github.com/lotusirous/gostdsym/stdsym@latest",
	cmd = { "GoDoc" },
	opts = {
		window = {
			type = "vsplit",
		},
		picker = {
			type = "snacks",
		},
	},
}
