return {
	"zbirenbaum/copilot.lua",
	cmd = "Copilot",
	build = ":Copilot auth",
	event = "InsertEnter",
	dependencies = {
		"folke/snacks.nvim",
	},
	config = function()
		-- Toggle Copilot from: https://github.com/zbirenbaum/copilot.lua/issues/302#issuecomment-2773096356
		Snacks.toggle({
			name = "Github Copilot",
			get = function()
				if not vim.g.copilot_enabled then -- HACK: since it's disabled by default the below will throw error
					return false
				end
				return not require("copilot.client").is_disabled()
			end,
			set = function(state)
				if state then
					require("copilot").setup() -- setting up for the very first time
					require("copilot.command").enable()
					vim.g.copilot_enabled = true
				else
					require("copilot.command").disable()
					vim.g.copilot_enabled = false
				end
			end,
		}):map("<leader>ux")
	end,
}
