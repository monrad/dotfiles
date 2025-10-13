return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons", "folke/sidekick.nvim" },
	config = function()
		local icons = {
			copilot = {
				enabled = "",
				disabled = "",
				warning = "",
				nes = {
					has = "󰭺",
					process = "󱋊",
				},
			},
		}
		-- local InlineCompletions = {
		-- 	function()
		-- 		local inline_completions_is_enabled = vim.lsp.inline_completion.is_enabled()
		-- 	end,
		-- 	cond = function()
		-- 		local inline_completions_is_enabled = vim.lsp.inline_completion.is_enabled()
		-- 		return inline_completions_is_enabled
		-- 	end,
		-- }
		local SidekickStatus = {
			function()
				local nes_is_enabled = require("sidekick.nes").enabled
				local sidekick_status = require("sidekick.status").get()
				local sidekick_has_nes = require("sidekick.nes").have()
				local sidekick_process_nes = next(require("sidekick.nes")._requests)
				local icon = not nes_is_enabled and icons.copilot.disabled
					or sidekick_status.kind == "Warning" and icons.copilot.warning
					or icons.copilot.enabled
				local icon_nes = sidekick_process_nes and icons.copilot.nes.process
					or sidekick_has_nes and icons.copilot.nes.has
					or ""
				return icon .. icon_nes
			end,
			color = function()
				local sidekick_status = require("sidekick.status").get()
				if sidekick_status then
					return sidekick_status.kind == "Error" and "DiagnosticError"
						or sidekick_status.busy and "DiagnosticWarn"
						or sidekick_status.kind == "Normal" and "Special"
						or nil
				end
			end,
			cond = function()
				local sidekick_has_status = require("sidekick.status").get() ~= nil
				return sidekick_has_status
			end,
		}
		require("lualine").setup({
			sections = {
				lualine_c = {
					SidekickStatus,
					{
						"filename",
						path = 1,
					},
				},
				lualine_x = {
					"encoding",
					"fileformat",
					"filetype",
					{
						require("noice").api.status.message.get_hl,
						cond = require("noice").api.status.message.has,
					},
					{
						require("noice").api.status.command.get,
						cond = require("noice").api.status.command.has,
						color = { fg = "#ff9e64" },
					},
					{
						require("noice").api.status.mode.get,
						cond = require("noice").api.status.mode.has,
						color = { fg = "#ff9e64" },
					},
					{
						require("noice").api.status.search.get,
						cond = require("noice").api.status.search.has,
						color = { fg = "#ff9e64" },
					},
				},
			},
		})
	end,
}
