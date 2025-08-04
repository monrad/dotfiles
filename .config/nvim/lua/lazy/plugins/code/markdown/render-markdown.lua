return {
	"MeanderingProgrammer/render-markdown.nvim",
	---@module 'render-markdown'
	---@type render.md.UserConfig
	opts = {
		file_types = { "markdown", "copilot-chat", "codecompanion" },
		completions = { blink = { enabled = true } },
	},
	ft = { "markdown", "copilot-chat", "codecompanion" },
	dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" }, -- if you prefer nvim-web-devicons
}
