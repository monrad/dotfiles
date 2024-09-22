return {
	"iamcco/markdown-preview.nvim",
	cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
	ft = { "markdown" },
	keys = {
		{ "C-p", "<cmd>MarkdownPreviewToggle<cr>", mode = "n" },
	},
	build = function()
		vim.fn["mkdp#util#install"]()
	end,
}
