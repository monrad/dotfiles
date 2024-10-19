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
		"folke/trouble.nvim",
		"nvim-lua/plenary.nvim",
		"nvim-neotest/neotest-python",
		"nvim-neotest/nvim-nio",
		"nvim-treesitter/nvim-treesitter",
		{
			"fredrikaverpil/neotest-golang",
			dependencies = {
				{
					"leoluz/nvim-dap-go",
				},
			},
		},
	},
	opts = {
		adapters = {
			["neotest-python"] = {},
			["neotest-golang"] = {
				go_test_args = {
					"-v",
					"-race",
					"-count=1",
					"-coverprofile=" .. vim.fn.getcwd() .. "/coverage.out",
					"-timeout=60s",
				},
				dap_go_enabled = true,
				runner = "gotestsum",
				-- gotestsum_args = { "--format=standard-verbose" },
				-- testify_enabled = true,
			},
		},
		status = { virtual_text = true },
		output = { open_on_run = true },
		quickfix = {
			open = function()
				require("trouble").open({ mode = "quickfix", focus = false })
			end,
		},
	},
	config = function(_, opts)
		local neotest_ns = vim.api.nvim_create_namespace("neotest")
		vim.diagnostic.config({
			virtual_text = {
				format = function(diagnostic)
					-- Replace newline and tab characters with space for more compact diagnostics
					local message = diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
					return message
				end,
			},
		}, neotest_ns)
		opts.consumers = opts.consumers or {}
		-- Refresh and auto close trouble after running tests
		---@type neotest.Consumer
		opts.consumers.trouble = function(client)
			client.listeners.results = function(adapter_id, results, partial)
				if partial then
					return
				end
				local tree = assert(client:get_position(nil, { adapter = adapter_id }))

				local failed = 0
				for pos_id, result in pairs(results) do
					if result.status == "failed" and tree:get_key(pos_id) then
						failed = failed + 1
					end
				end
				vim.schedule(function()
					local trouble = require("trouble")
					if trouble.is_open() then
						trouble.refresh()
						if failed == 0 then
							trouble.close()
						end
					end
				end)
				return {}
			end
		end
		if opts.adapters then
			local adapters = {}
			for name, config in pairs(opts.adapters or {}) do
				if type(name) == "number" then
					if type(config) == "string" then
						config = require(config)
					end
					adapters[#adapters + 1] = config
				elseif config ~= false then
					local adapter = require(name)
					if type(config) == "table" and not vim.tbl_isempty(config) then
						local meta = getmetatable(adapter)
						if adapter.setup then
							adapter.setup(config)
						elseif adapter.adapter then
							adapter.adapter(config)
							adapter = adapter.adapter
						elseif meta and meta.__call then
							adapter = adapter(config)
						else
							error("Adapter " .. name .. " does not support setup")
						end
					end
					adapters[#adapters + 1] = adapter
				end
			end
			opts.adapters = adapters
		end
		require("neotest").setup(opts)
		-- set up logging
		-- local log_level = vim.log.levels.DEBUG
		-- require("neotest.logging"):set_level(log_level)
		-- vim.notify("Logging for Neotest enabled", vim.log.levels.WARN)
		-- local filepath = require("neotest.logging"):get_filename()
		-- vim.notify("Neotest log file: " .. filepath, vim.log.levels.INFO)
	end,
}
