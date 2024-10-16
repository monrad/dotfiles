-- Useful plugin to show you pending keybinds.
return {
	"folke/which-key.nvim",
	event = "VimEnter", -- Sets the loading event to 'VimEnter'
	opts = {
		icons = {
			-- set icon mappings to true if you have a Nerd Font
			mappings = vim.g.have_nerd_font,
			-- If you are using a Nerd Font: set icons.keys to an empty table which will use the
			-- default whick-key.nvim defined Nerd Font icons, otherwise define a string table
			keys = vim.g.have_nerd_font and {} or {
				Up = "<Up> ",
				Down = "<Down> ",
				Left = "<Left> ",
				Right = "<Right> ",
				C = "<C-…> ",
				M = "<M-…> ",
				D = "<D-…> ",
				S = "<S-…> ",
				CR = "<CR> ",
				Esc = "<Esc> ",
				ScrollWheelDown = "<ScrollWheelDown> ",
				ScrollWheelUp = "<ScrollWheelUp> ",
				NL = "<NL> ",
				BS = "<BS> ",
				Space = "<Space> ",
				Tab = "<Tab> ",
				F1 = "<F1>",
				F2 = "<F2>",
				F3 = "<F3>",
				F4 = "<F4>",
				F5 = "<F5>",
				F6 = "<F6>",
				F7 = "<F7>",
				F8 = "<F8>",
				F9 = "<F9>",
				F10 = "<F10>",
				F11 = "<F11>",
				F12 = "<F12>",
			},
		},
		-- Document existing key chains
		spec = {
			{ "<leader>c", group = "[c]ode", mode = { "n", "x" } },
			{ "<leader>ci", group = "[c]ode [i]ncremental selection", mode = { "n", "x" } },
			{ "<leader>cg", group = "[c]ode [g]o utils", mode = { "n", "x" } },
			{ "<leader>d", group = "[d]ocument" },
			{ "<leader>r", group = "[r]un" },
			{ "<leader>v", group = "co[v]erage" },
			{ "<leader>rt", group = "[r]un [t]est" },
			{ "<leader>s", group = "[s]earch" },
			{ "<leader>w", group = "[w]orkspace" },
			{ "<leader>t", group = "[t]oggle" },
			{ "<leader>tt", group = "[t]oggle [t]est" },
			{ "<leader>g", group = "[g]it", mode = { "n", "v" } },
			{ "<leader>n", group = "[n]otifications" },
			{ "<leader>gw", group = "[g]it [w]orktree" },
			{ "<leader>gh", group = "[g]it [h]unk", mode = { "n", "v" } },
		},
	},
}
