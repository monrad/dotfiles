return {
	"nvim-neotest/neotest",
	keys = {
		{
			"<leader>rta",
			function()
				require("neotest").run.attach()
			end,
			desc = "[r]un [t]est [a]ttach",
		},
		{
			"<leader>rtf",
			function()
				require("neotest").run.run(vim.fn.expand("%"))
			end,
			desc = "[r]un [t]est [f]ile",
		},
		{
			"<leader>rtA",
			function()
				require("neotest").run.run(vim.uv.cwd())
			end,
			desc = "[r]un [t]est [A]ll files",
		},
		{
			"<leader>rtS",
			function()
				require("neotest").run.run({ suite = true })
			end,
			desc = "[r]un [t]est [S]uite",
		},
		{
			"<leader>rtn",
			function()
				require("neotest").run.run()
			end,
			desc = "[r]un [t]est [n]earest",
		},
		{
			"<leader>rtl",
			function()
				require("neotest").run.run_last()
			end,
			desc = "[r]un [t]est [l]ast",
		},
		{
			"<leader>tts",
			function()
				require("neotest").summary.toggle()
			end,
			desc = "[t]oggle [t]est [s]ummary",
		},
		{
			"<leader>tto",
			function()
				require("neotest").output.open({ enter = true, auto_close = true })
			end,
			desc = "[t]oggle [t]est [o]utput",
		},
		{
			"<leader>ttO",
			function()
				require("neotest").output_panel.toggle()
			end,
			desc = "[t]oggle [t]est [O]utput panel",
		},
		{
			"<leader>rtt",
			function()
				require("neotest").run.stop()
			end,
			desc = "[r]un [t]est [t]erminate",
		},
		{
			"<leader>rtd",
			function()
				require("neotest").run.run({ suite = false, strategy = "dap" })
			end,
			desc = "[r]un nearest [t]est [d]ebug",
		},
		{
			"<leader>rtD",
			function()
				require("neotest").run.run({ vim.fn.expand("%"), strategy = "dap" })
			end,
			desc = "[r]un [t]est current file [d]ebug",
		},
	},
	dependencies = {
		"nvim-neotest/nvim-nio",
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
		"nvim-neotest/neotest-python",
		{
			"fredrikaverpil/neotest-golang",
			dependencies = {
				{
					"leoluz/nvim-dap-go",
				},
			},
			version = "*",
		},
	},
	config = function()
		local golang_config = {
			go_test_args = {
				"-v",
				"-race",
				"-count=1",
				"-coverprofile=" .. vim.fn.getcwd() .. "/coverage.out",
				runner = "gotestsum",
				gotestsum_args = { "--format=standard-verbose" },
				testify_enabled = true,
			},
		}
		require("neotest").setup({
			adapters = {
				require("neotest-golang")(golang_config),
				require("neotest-python"),
			},
		})
		-- set up logging
		-- local log_level = vim.log.levels.DEBUG
		-- require("neotest.logging"):set_level(log_level)
		-- vim.notify("Logging for Neotest enabled", vim.log.levels.WARN)
		-- local filepath = require("neotest.logging"):get_filename()
		-- vim.notify("Neotest log file: " .. filepath, vim.log.levels.INFO)
	end,
}
