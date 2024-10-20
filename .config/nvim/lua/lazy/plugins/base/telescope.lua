-- Fuzzy Finder (files, lsp, etc)
return {
	"nvim-telescope/telescope.nvim",
	event = "VimEnter",
	branch = "0.1.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ -- If encountering errors, see telescope-fzf-native README for install instructions
			"nvim-telescope/telescope-fzf-native.nvim",

			-- `build` is used to run some command when the plugin is installed/updated.
			-- This is only run then, not every time Neovim starts up.
			build = "make",

			-- `cond` is a condition used to determine whether this plugin should be
			-- installed and loaded.
			cond = function()
				return vim.fn.executable("make") == 1
			end,
		},
		{ "nvim-telescope/telescope-ui-select.nvim" },

		-- Useful for getting pretty icons, but requires a Nerd Font.
		{ "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
	},
	config = function()
		-- Telescope is a fuzzy finder that comes with a lot of different things that
		-- it can fuzzy find! It's more than just a "file finder", it can search
		-- many different aspects of Neovim, your workspace, LSP, and more!
		--
		-- The easiest way to use telescope, is to start by doing something like:
		--  :Telescope help_tags
		--
		-- After running this command, a window will open up and you're able to
		-- type in the prompt window. You'll see a list of help_tags options and
		-- a corresponding preview of the help.
		--
		-- Two important keymaps to use while in telescope are:
		--  - Insert mode: <c-/>
		--  - Normal mode: ?
		--
		-- This opens a window that shows you all of the keymaps for the current
		-- telescope picker. This is really useful to discover what Telescope can
		-- do as well as how to actually do it!

		-- [[ Configure Telescope ]]
		-- See `:help telescope` and `:help telescope.setup()`
		require("telescope").setup({
			-- You can put your default mappings / updates / etc. in here
			--  All the info you're looking for is in `:help telescope.setup()`
			--tpope/vim-sleuth
			-- defaults = {
			--   mappings = {
			--     i = { ['<c-enter>'] = 'to_fuzzy_refine' },
			--   },
			-- },
			defaults = {
				-- Default configuration for telescope goes here:
				-- config_key = value,
				mappings = {
					n = {
						["<c-d>"] = require("telescope.actions").delete_buffer,
					}, -- n
					i = {
						["<C-h>"] = "which_key",
						["<c-d>"] = require("telescope.actions").delete_buffer,
					}, -- i
				}, -- mappings
			}, -- defaults
			-- pickers = {}
			extensions = {
				["ui-select"] = {
					require("telescope.themes").get_dropdown(),
				},
			},
		})

		-- Enable telescope extensions, if they are installed
		pcall(require("telescope").load_extension, "fzf")
		pcall(require("telescope").load_extension, "ui-select")
		pcall(require("telescope").load_extension, "git_worktree")

		-- See `:help telescope.builtin`
		local builtin = require("telescope.builtin")
		-- Find
		vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "[ ] find existing buffers" })
		vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find Files (Root dir)" })
		vim.keymap.set("n", "<leader>fF", function()
			builtin.find_files({ cwd = vim.uv.cwd() })
		end, { desc = "Find Files (cwd)" })
		vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find Files" })
		vim.keymap.set("n", "<leader>fg", builtin.git_files, { desc = "Find Files (git-files)" })
		vim.keymap.set("n", "<leader>fr", builtin.oldfiles, { desc = "Recent" })
		-- Git
		vim.keymap.set("n", "<leader>gc", builtin.git_commits, { desc = "Commits" })
		vim.keymap.set("n", "<leader>gs", builtin.git_status, { desc = "Status" })
		-- Search
		vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "Grep (Root dir)" })
		vim.keymap.set("n", "<leader>sG", function()
			builtin.live_grep({ cwd = vim.uv.cwd() })
		end, { desc = "Grep (cwd)" })
		vim.keymap.set("n", "<leader>sR", builtin.resume, { desc = "Resume" })
		vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "Help" })
		vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "Keymaps" })
		vim.keymap.set("n", "<leader>st", builtin.builtin, { desc = "Telescope" })
		vim.keymap.set("n", "<leader>sm", builtin.marks, { desc = "Jump to Marks" })
		vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "Current word" })
		-- vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[s]earch [d]iagnostics" })
		vim.keymap.set("n", '<leader>s"', builtin.registers, { desc = "Registers" })

		-- Slightly advanced example of overriding default behavior and theme
		vim.keymap.set("n", "<leader>sb", function()
			builtin.current_buffer_fuzzy_find()
		end, { desc = "Buffer" })

		-- Also possible to pass additional configuration options.
		--  See `:help telescope.builtin.live_grep()` for information about particular keys
		vim.keymap.set("n", "<leader>s/", function()
			builtin.live_grep({
				grep_open_files = true,
				prompt_title = "Live Grep in Open Files",
			})
		end, { desc = "Open files" })
	end,
}
