return {
	"NvChad/nvim-colorizer.lua",
	event = "BufReadPre",
	opts = {
		filetypes = {
			"*",
			templ = {
				tailwind = true,
			},
		},
	},
}
