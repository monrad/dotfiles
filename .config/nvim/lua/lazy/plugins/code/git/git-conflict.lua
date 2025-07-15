return {
	"akinsho/git-conflict.nvim",
	version = "*",
	config = function()
		require("git-conflict").setup({
			default_mappings = false,
		})
		vim.keymap.set("n", "<leader>goo", "<cmd>GitConflictChooseOurs<cr>")
		vim.keymap.set("n", "<leader>got", "<cmd>GitConflictChooseTheirs<cr>")
		vim.keymap.set("n", "<leader>go0", "<cmd>GitConflictChooseNone<cr>")
		vim.keymap.set("n", "<leader>gon", "<cmd>GitConflictNextConflict<cr>")
		vim.keymap.set("n", "<leader>gop", "<cmd>GitConflictPrevConflict<cr>")
	end,
}
