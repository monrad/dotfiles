-- Useful plugin to show you pending keybinds.
return {
	"folke/which-key.nvim",
	event = "VimEnter", -- Sets the loading event to 'VimEnter'
	opts = {
		-- delay between pressing a key and opening which-key (milliseconds)
		-- this setting is independent of vim.opt.timeoutlen
		delay = 0,
		icons = {
			-- set icon mappings to true if you have a Nerd Font
			mappings = vim.g.have_nerd_font,
			-- If you are using a Nerd Font: set icons.keys to an empty table which will use the
			-- default whick-key.nvim defined Nerd Font icons, otherwise define a string table
			keys = {},
		},
		-- Document existing key chains
		spec = {
			{ "<leader>a", group = "ai" },
			{ "<leader>c", group = "code", mode = { "n", "x" } },
			{ "<leader>d", group = "debug", mode = { "n", "v" } },
			{ "<leader>f", group = "file/find", mode = { "n", "v" } },
			{ "<leader>g", group = "git", mode = { "n", "v" } },
			{ "<leader>gh", group = "hunk", mode = { "n", "v" } },
			{ "<leader>q", group = "quit/session", mode = { "n", "v" } },
			{ "<leader>s", group = "search", mode = { "n", "v" } },
			{ "<leader>u", group = "ui", icon = { icon = "󰙵 ", color = "cyan" }, mode = { "n", "v" } },
			{ "<leader>x", group = "diagnostics/quickfix", icon = { icon = "󱖫 ", color = "green" } },
		},
	},
	keys = {
		{
			"<leader>?",
			function()
				require("which-key").show({ global = false })
			end,
			desc = "Buffer Keymaps (which-key)",
		},
	},
}
