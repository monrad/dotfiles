return {
	"nvim-neotest/neotest",
	keys = {
		{ "<leader>t", "", desc = "+test" },
		{
			"<leader>tt",
			function()
				require("neotest").run.run(vim.fn.expand("%"))
			end,
			desc = "Run File",
		},
		{
			"<leader>tT",
			function()
				require("neotest").run.run(vim.uv.cwd())
			end,
			desc = "Run All Test Files",
		},
		{
			"<leader>tr",
			function()
				require("neotest").run.run()
			end,
			desc = "Run Nearest",
		},
		{
			"<leader>td",
			function()
				require("neotest").run.run({ strategy = "dap" })
			end,
			desc = "Run Nearest (Debug)",
		},
		{
			"<leader>tl",
			function()
				require("neotest").run.run_last()
			end,
			desc = "Run Last",
		},
		{
			"<leader>ts",
			function()
				require("neotest").summary.toggle()
			end,
			desc = "Toggle Summary",
		},
		{
			"<leader>to",
			function()
				require("neotest").output.open({ enter = true, auto_close = true })
			end,
			desc = "Show Output",
		},
		{
			"<leader>tO",
			function()
				require("neotest").output_panel.toggle()
			end,
			desc = "Toggle Output Panel",
		},
		{
			"<leader>tS",
			function()
				require("neotest").run.stop()
			end,
			desc = "Stop",
		},
		{
			"<leader>tw",
			function()
				require("neotest").watch.toggle(vim.fn.expand("%"))
			end,
			desc = "Toggle Watch",
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
			["neotest-python"] = {
				args = { "-n0" },
			},
			["neotest-golang"] = {
				go_test_args = {
					"-v",
					"-race",
					"-count=1",
					-- "-coverprofile=" .. vim.fn.getcwd() .. "/coverage.out",
					"-coverprofile=./coverage.out",
					"-timeout=60s",
				},
				dap_go_enabled = true,
				runner = "gotestsum",
				gotestsum_args = { "--format=standard-verbose" },
				-- log_level = vim.log.levels.TRACE,
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
			end
			return {}
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
