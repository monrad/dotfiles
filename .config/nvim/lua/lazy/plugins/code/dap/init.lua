-- debug.lua
--
-- Shows how to use the DAP plugin to debug your code.
--
-- Primarily focused on configuring the debugger for Go, but can
-- be extended to other languages as well. That's why it's called
-- kickstart.nvim and not kitchen-sink.nvim ;)

return {
	"mfussenegger/nvim-dap",
	dependencies = {
		-- Creates a beautiful debugger UI
		"rcarriga/nvim-dap-ui",

		-- Required dependency for nvim-dap-ui
		"nvim-neotest/nvim-nio",

		-- Installs the debug adapters for you
		"williamboman/mason.nvim",
		"jay-babu/mason-nvim-dap.nvim",

		-- Add your own debuggers here
		"leoluz/nvim-dap-go",
		"mfussenegger/nvim-dap-python",

		-- Add virtual text to make go plugin happy
		"theHamsta/nvim-dap-virtual-text",
	},
	keys = function(_, keys)
		local dap = require("dap")
		local dapui = require("dapui")
		return {
			{
				"<leader>dB",
				function()
					dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
				end,
				desc = "Breakpoint Condition",
			},
			{
				"<leader>db",
				function()
					dap.toggle_breakpoint()
				end,
				desc = "Toggle Breakpoint",
			},
			{
				"<leader>dc",
				function()
					dap.continue()
				end,
				desc = "Continue",
			},
			{
				"<leader>dC",
				function()
					dap.run_to_cursor()
				end,
				desc = "Run to Cursor",
			},
			{
				"<leader>dg",
				function()
					dap.goto_()
				end,
				desc = "Go to Line (No Execute)",
			},
			{
				"<leader>di",
				function()
					dap.step_into()
				end,
				desc = "Step Into",
			},
			{
				"<leader>dj",
				function()
					dap.down()
				end,
				desc = "Down",
			},
			{
				"<leader>dk",
				function()
					dap.up()
				end,
				desc = "Up",
			},
			{
				"<leader>dl",
				function()
					dap.run_last()
				end,
				desc = "Run Last",
			},
			{
				"<leader>do",
				function()
					dap.step_out()
				end,
				desc = "Step Out",
			},
			{
				"<leader>dO",
				function()
					dap.step_over()
				end,
				desc = "Step Over",
			},
			{
				"<leader>dp",
				function()
					dap.pause()
				end,
				desc = "Pause",
			},
			{
				"<leader>dr",
				function()
					dap.repl.toggle()
				end,
				desc = "Toggle REPL",
			},
			{
				"<leader>ds",
				function()
					dap.session()
				end,
				desc = "Session",
			},
			{
				"<leader>dt",
				function()
					dap.terminate()
				end,
				desc = "Terminate",
			},
			{
				"<leader>dw",
				function()
					require("dap.ui.widgets").hover()
				end,
				desc = "Widgets",
			},
			{
				"<leader>du",
				function()
					dapui.toggle({})
				end,
				desc = "Dap UI",
			},
			{
				"<leader>de",
				function()
					dapui.eval()
				end,
				desc = "Eval",
				mode = { "n", "v" },
			},
			unpack(keys),
		}
	end,
	config = function()
		local dap = require("dap")
		local dapui = require("dapui")

		require("mason-nvim-dap").setup({
			-- Makes a best effort to setup the various debuggers with
			-- reasonable debug configurations
			automatic_installation = true,

			-- You can provide additional configuration to the handlers,
			-- see mason-nvim-dap README for more information
			handlers = {},

			-- You'll need to check that you have the required things installed
			-- online, please don't ask me how to install them :)
			ensure_installed = {
				-- Update this to ensure that you have the debuggers for the langs you want
				"delve",
			},
		})

		-- Lets do some logging
		-- require("dap").set_log_level "INFO"

		-- setup dap config by VsCode launch.json file
		local vscode = require("dap.ext.vscode")
		local json = require("plenary.json")
		vscode.json_decode = function(str)
			return vim.json.decode(json.json_strip_comments(str))
		end

		-- Dap UI setup
		-- For more information, see |:help nvim-dap-ui|
		dapui.setup()

		dap.listeners.after.event_initialized["dapui_config"] = dapui.open
		dap.listeners.before.event_terminated["dapui_config"] = dapui.close
		dap.listeners.before.event_exited["dapui_config"] = dapui.close

		-- Install golang specific config
		require("dap-go").setup()
	end,
}
