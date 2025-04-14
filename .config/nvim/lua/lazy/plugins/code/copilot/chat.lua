return {
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		dependencies = {
			{ "zbirenbaum/copilot.lua" },
			{ "nvim-lua/plenary.nvim" }, -- for curl, log and async functions
		},
		build = "make tiktoken", -- Only on MacOS or Linux
		opts = {
			-- See Configuration section for options
			highlight_headers = false,
			separator = "---",
			error_header = "> [!ERROR] Error",
		},
		-- See Commands section for default commands if you want to lazy load on them
	},
}
