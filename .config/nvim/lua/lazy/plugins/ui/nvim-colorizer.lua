return {
	"NvChad/nvim-colorizer.lua",
	event = "BufReadPre",
	opts = {
		filetypes = {
			"html",
			"javascript",
			"css",
			templ = {
				tailwind = true,
			},
		},
	},
}
