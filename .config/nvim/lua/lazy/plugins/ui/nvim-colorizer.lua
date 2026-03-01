return {
	"catgoose/nvim-colorizer.lua",
	event = "BufReadPre",
	opts = {
		options = {
			filetypes = {
				"html",
				"javascript",
				"css",
				templ = {
					tailwind = true,
				},
			},
		},
	},
}
