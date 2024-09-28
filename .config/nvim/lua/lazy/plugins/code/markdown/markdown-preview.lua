return {
	"iamcco/markdown-preview.nvim",
	cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
	ft = { "markdown" },
	keys = {
		{ "<leader>tP", "<cmd>MarkdownPreviewToggle<cr>", desc = "[t]oggle [P]review", ft = "markdown" },
	},
	build = function()
		vim.fn["mkdp#util#install"]()
	end,
}
