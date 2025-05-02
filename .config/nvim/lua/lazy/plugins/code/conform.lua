-- Autoformatting
return {
	"stevearc/conform.nvim",
	dependencies = {
		"rcarriga/nvim-notify",
	},
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	keys = {
		{
			"<leader>cf",
			function()
				require("conform").format({ async = true, lsp_format = "fallback" })
			end,
			mode = "",
			desc = "Format",
		},
		{
			"<leader>uF",
			":FormatToggle!<cr>",
			desc = "Disable Auto Format (buffer)",
		},
		{
			"<leader>uf",
			":FormatToggle<cr>",
			desc = "Disable Auto Format (global)",
		},
	},
	opts = {
		notify_on_error = false,
		format_on_save = function(bufnr)
			-- Disable "format_on_save lsp_fallback" for languages that don't
			-- have a well standardized coding style. You can add additional
			-- languages here or re-enable it for the disabled ones.
			local disable_filetypes = { c = true, cpp = true }
			local lsp_format_opt
			-- Disable with a global or buffer-local variable
			if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
				return
			end
			if disable_filetypes[vim.bo[bufnr].filetype] then
				lsp_format_opt = "never"
			else
				lsp_format_opt = "fallback"
			end
			return {
				timeout_ms = 2000,
				lsp_format = lsp_format_opt,
			}
		end,
		vim.api.nvim_create_user_command("FormatToggle", function(args)
			local notify = require("notify")
			local function show_notification(message, level)
				notify(message, level, { title = "conform.nvim" })
			end
			local is_global = not args.bang
			if is_global then
				vim.g.disable_autoformat = not vim.g.disable_autoformat
				if vim.g.disable_autoformat then
					show_notification("Autoformat-on-save disabled globally", "info")
				else
					show_notification("Autoformat-on-save enabled globally", "info")
				end
			else
				vim.b.disable_autoformat = not vim.b.disable_autoformat
				if vim.b.disable_autoformat then
					show_notification("Autoformat-on-save disabled for this buffer", "info")
				else
					show_notification("Autoformat-on-save enabled for this buffer", "info")
				end
			end
		end, {
			desc = "Toggle autoformat-on-save",
			bang = true,
		}),
		formatters = {
			["markdown-toc"] = {
				condition = function(_, ctx)
					for _, line in ipairs(vim.api.nvim_buf_get_lines(ctx.buf, 0, -1, false)) do
						if line:find("<!%-%- toc %-%->") then
							return true
						end
					end
				end,
			},
			["markdownlint-cli2"] = {
				condition = function(_, ctx)
					local diag = vim.tbl_filter(function(d)
						return d.source == "markdownlint"
					end, vim.diagnostic.get(ctx.buf))
					return #diag > 0
				end,
			},
		},
		formatters_by_ft = {
			lua = { "stylua" },
			markdown = { "prettierd", "markdownlint-cli2", "markdown-toc" },
			proto = { "buf" },
			templ = { "rustywind", "templ" },
			toml = { "taplo" },
			yaml = { "prettierd" },
			python = function(bufnr)
				if require("conform").get_formatter_info("ruff_format", bufnr).available then
					return { "ruff_organize_imports", "ruff_format" }
				else
					return { "isort", "black" }
				end
			end,
			--
			-- You can use 'stop_after_first' to run the first available formatter from the list
			-- javascript = { "prettierd", "prettier", stop_after_first = true },
			--
			go = function(bufnr)
				if require("conform").get_formatter_info("golangci-lint", bufnr).available then
					return { "golangci-lint" }
				else
					return { "goimports", "gofumpt" }
				end
			end,
		},
	},
}
