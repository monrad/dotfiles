return {
	{ -- Linting
		"mfussenegger/nvim-lint",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local lint = require("lint")
			lint.linters_by_ft["clojure"] = nil
			lint.linters_by_ft["dockerfile"] = { "hadolint" }
			lint.linters_by_ft["inko"] = nil
			lint.linters_by_ft["janet"] = nil
			lint.linters_by_ft["json"] = { "jsonlint" }
			lint.linters_by_ft["markdown"] = { "markdownlint" }
			lint.linters_by_ft["rst"] = { "vale" }
			lint.linters_by_ft["ruby"] = { "ruby" }
			lint.linters_by_ft["sh"] = { "shellcheck" }
			lint.linters_by_ft["terraform"] = { "tflint" }
			lint.linters_by_ft["text"] = { "vale" }

			-- configure markdownlint
			local markdownlint = require("lint").linters.markdownlint
			markdownlint.args = {
				"--disable",
				"MD013",
				"--stdin", -- Required
			}
			-- Create autocommand which carries out the actual linting
			-- on the specified events.
			local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
			vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
				group = lint_augroup,
				callback = function()
					lint.try_lint()
				end,
			})
		end,
	},
}
