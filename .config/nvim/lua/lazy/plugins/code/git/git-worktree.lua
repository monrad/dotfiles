return {
	"polarmutex/git-worktree.nvim",
	-- version = "^2",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"rcarriga/nvim-notify",
		-- Using Oil as file browser
		"stevearc/oil.nvim",
	},
	opt = {},
	keys = {
		{ "<leader>gwl", "<cmd>Telescope git_worktree git_worktree<cr>", mode = "n", desc = "[g]it [w]orktree [l]ist" },
		{
			"<leader>gws",
			"<cmd>Telescope git_worktree git_worktree<cr>",
			mode = "n",
			desc = "[g]it [w]orktree [s]witch",
		},
		{
			"<leader>gwc",
			"<cmd>Telescope git_worktree create_git_worktree<cr>",
			mode = "n",
			desc = "[g]it [w]orktree [c]reate",
		},
	},
	config = function()
		local Hooks = require("git-worktree.hooks")
		local config = require("git-worktree.config")
		local notify = require("notify")

		Hooks.register(Hooks.type.SWITCH, function(path, prev_path)
			notify("Switched from " .. prev_path .. " to " .. path, "info", { title = "git-worktree.nvim" })
			if vim.fn.expand("%"):find("^oil:///") then
				require("oil").open(vim.fn.getcwd())
			else
				Hooks.builtins.update_current_buffer_on_switch(path, prev_path)
				require("arrow.persist").load_cache_file()
			end
		end)

		Hooks.register(Hooks.type.DELETE, function()
			vim.cmd(config.update_on_change_command)
		end)
	end,
}
