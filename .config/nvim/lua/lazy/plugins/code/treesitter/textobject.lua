return {
	"nvim-treesitter/nvim-treesitter-textobjects",
	branch = "main",
	event = "VeryLazy",
	dependencies = { "nvim-treesitter/nvim-treesitter" },
	config = function()
		require("nvim-treesitter-textobjects").setup({
			select = {
				lookahead = true,
			},
			move = {
				set_jumps = true,
			},
		})

		local map = vim.keymap.set

		-- Textobject selections
		map({ "x", "o" }, "af", function()
			require("nvim-treesitter-textobjects.select").select_textobject("@function.outer", "textobjects")
		end, { desc = "outer function" })
		map({ "x", "o" }, "if", function()
			require("nvim-treesitter-textobjects.select").select_textobject("@function.inner", "textobjects")
		end, { desc = "inner function" })
		map({ "x", "o" }, "ac", function()
			require("nvim-treesitter-textobjects.select").select_textobject("@class.outer", "textobjects")
		end, { desc = "outer class" })
		map({ "x", "o" }, "ic", function()
			require("nvim-treesitter-textobjects.select").select_textobject("@class.inner", "textobjects")
		end, { desc = "inner class" })
		map({ "x", "o" }, "aa", function()
			require("nvim-treesitter-textobjects.select").select_textobject("@parameter.outer", "textobjects")
		end, { desc = "outer argument" })
		map({ "x", "o" }, "ia", function()
			require("nvim-treesitter-textobjects.select").select_textobject("@parameter.inner", "textobjects")
		end, { desc = "inner argument" })

		-- Movement
		map({ "n", "x", "o" }, "]f", function()
			require("nvim-treesitter-textobjects.move").goto_next_start("@function.outer", "textobjects")
		end, { desc = "Next function start" })
		map({ "n", "x", "o" }, "[f", function()
			require("nvim-treesitter-textobjects.move").goto_previous_start("@function.outer", "textobjects")
		end, { desc = "Previous function start" })
		map({ "n", "x", "o" }, "]F", function()
			require("nvim-treesitter-textobjects.move").goto_next_end("@function.outer", "textobjects")
		end, { desc = "Next function end" })
		map({ "n", "x", "o" }, "[F", function()
			require("nvim-treesitter-textobjects.move").goto_previous_end("@function.outer", "textobjects")
		end, { desc = "Previous function end" })
		map({ "n", "x", "o" }, "]c", function()
			require("nvim-treesitter-textobjects.move").goto_next_start("@class.outer", "textobjects")
		end, { desc = "Next class start" })
		map({ "n", "x", "o" }, "[c", function()
			require("nvim-treesitter-textobjects.move").goto_previous_start("@class.outer", "textobjects")
		end, { desc = "Previous class start" })
	end,
}
