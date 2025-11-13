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
			lint.linters_by_ft["rst"] = nil
			lint.linters_by_ft["ruby"] = { "ruby" }
			lint.linters_by_ft["sh"] = { "shellcheck" }
			lint.linters_by_ft["systemd"] = { "systemdlint" }
			lint.linters_by_ft["terraform"] = { "tflint" }
			lint.linters_by_ft["text"] = nil
			lint.linters_by_ft["sql"] = { "sqlfluff" }

			-- configure markdownlint
			local markdownlint = require("lint").linters.markdownlint
			markdownlint.args = {
				"--disable",
				"MD013",
				"--stdin", -- Required
			}
			-- configure systemdlint
			local systemdlint = require("lint").linters.systemdlint
			systemdlint.args = {
				"--messageformat={path}:{line}:{severity}:{id}:{msg}",
				"--norootfs",
			}
			-- Create autocommand which carries out the actual linting
			-- on the specified events.
			local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
			vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
				group = lint_augroup,
				callback = function()
					-- Only run the linter in buffers that you can modify in order to
					-- avoid superfluous noise, notably within the handy LSP pop-ups that
					-- describe the hovered symbol using Markdown.
					if vim.opt_local.modifiable:get() then
						lint.try_lint()
					end
				end,
			})
		end,
	},
}
