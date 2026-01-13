-- LSP config
return {
	-- Main LSP Configuration
	"neovim/nvim-lspconfig",
	dependencies = {
		-- Automatically install LSPs and related tools to stdpath for neovim
		-- Mason must be loaded before its dependents so we need to set it up here.
		-- NOTE: `opts = {}` is the same as calling `require('mason').setup({})`
		{ "mason-org/mason.nvim", opts = {} },
		"mason-org/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",

		-- Allows extra capabilities provided by blink.cmp
		"saghen/blink.cmp",
	},
	config = function()
		-- Brief Aside: **What is LSP?**
		--
		-- LSP is an acronym you've probably heard, but might not understand what it is.
		--
		-- LSP stands for Language Server Protocol. It's a protocol that helps editors
		-- and language tooling communicate in a standardized fashion.
		--
		-- In general, you have a "server" which is some tool built to understand a particular
		-- language (such as `gopls`, `lua_ls`, `rust_analyzer`, etc). These Language Servers
		-- (sometimes called LSP servers, but that's kind of like ATM Machine) are standalone
		-- processes that communicate with some "client" - in this case, Neovim!
		--
		-- LSP provides Neovim with features like:
		--  - Go to definition
		--  - Find references
		--  - Autocompletion
		--  - Symbol Search
		--  - and more!
		--
		-- Thus, Language Servers are external tools that must be installed separately from
		-- Neovim. This is where `mason` and related plugins come into play.
		--
		-- If you're wondering about lsp vs treesitter, you can check out the wonderfully
		-- and elegantly composed help section, `:help lsp-vs-treesitter`

		-- Set Mason Keymap
		vim.keymap.set("n", "<leader>cm", "<cmd>Mason<cr>", { desc = "Mason" })
		--  This function gets run when an LSP attaches to a particular buffer.
		--    That is to say, every time a new file is opened that is associated with
		--    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
		--    function will be executed to configure the current buffer
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("dotfiles-lsp-attach", { clear = true }),
			callback = function(event)
				local map = function(keys, func, desc, mode, expr)
					mode = mode or "n"
					expr = expr or false
					vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = desc })
				end

				map("K", vim.lsp.buf.hover, "Hover")
				map("gD", vim.lsp.buf.declaration, "Goto Declaration")
				map("gK", vim.lsp.buf.signature_help, "Signature Help")

				map("<leader>cL", vim.lsp.codelens.refresh, "Refresh & Display Codelens")
				map("<leader>ca", vim.lsp.buf.code_action, "Code Action", { "n", "v", "x" })
				map("<leader>cl", vim.lsp.codelens.run, "Run Codelens", { "n", "v" })
				vim.keymap.set("n", "<leader>cr", function()
					return ":IncRename " .. vim.fn.expand("<cword>")
				end, { expr = true, desc = "Rename" })

				-- The following two autocommands are used to highlight references of the
				-- word under your cursor when your cursor rests there for a little while.
				--    See `:help CursorHold` for information about when this is executed
				--
				-- When you move your cursor, the highlights will be cleared (the second autocommand).
				local client = vim.lsp.get_client_by_id(event.data.client_id)
				if
					client
					and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf)
				then
					local highlight_augroup = vim.api.nvim_create_augroup("dotfiles-lsp-highlight", { clear = false })
					vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
						buffer = event.buf,
						group = highlight_augroup,
						callback = vim.lsp.buf.document_highlight,
					})

					vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
						buffer = event.buf,
						group = highlight_augroup,
						callback = vim.lsp.buf.clear_references,
					})

					vim.api.nvim_create_autocmd("LspDetach", {
						group = vim.api.nvim_create_augroup("dotfiles-lsp-detach", { clear = true }),
						callback = function(event2)
							vim.lsp.buf.clear_references()
							vim.api.nvim_clear_autocmds({ group = "dotfiles-lsp-highlight", buffer = event2.buf })
						end,
					})
				end

				-- The following code creates a keymap to toggle inlay hints in your
				-- code, if the language server you are using supports them
				--
				-- This may be unwanted, since they displace some of your code
				if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
					Snacks.toggle.inlay_hints():map("<leader>uh")

					-- Enable inlay hints by default
					vim.lsp.inlay_hint.enable()
				end
			end,
		})

		-- Language servers can broadly be installed in the following ways:
		--  1) via the mason package manager; or
		--  2) via your system's package manager; or
		--  3) via a release binary from a language server's repo that's accessible somewhere on your system.

		-- The servers table comprises of the following sub-tables:
		-- 1. mason
		-- 2. others
		-- Both these tables have an identical structure of language server names as keys and
		-- a table of language server configuration as values.

		---@class LspServersConfig
		---@field mason table<string, vim.lsp.Config>
		---@field others table<string, vim.lsp.Config>
		local servers = {
			mason = {
				ansiblels = {},
				arduino_language_server = {},
				basedpyright = {
					settings = {
						basedpyright = {
							analysis = {
								typeCheckingMode = "recommended",
								inlayHints = {
									variableTypes = false,
									callArgumentNames = false,
									functionReturnTypes = false,
									genericTypes = false,
								},
							},
						},
					},
				},
				bashls = {},
				buf_ls = {},
				copilot = {},
				docker_compose_language_service = {},
				dockerls = {},
				golangci_lint_ls = {},
				gopls = {
					settings = {
						gopls = {
							analyses = {
								useany = true,
								modernize = true,
								ST1000 = false,
							},
							codelenses = {
								gc_details = true, -- Show a code lens toggling the display of gc's choices.
								test = true,
								run_govulncheck = true,
							},
							hints = {
								assignVariableTypes = true,
								compositeLiteralFields = true,
								compositeLiteralTypes = true,
								constantValues = true,
								functionTypeParameters = true,
								parameterNames = true,
								rangeVariableTypes = true,
							},
							usePlaceholders = true,
							completeUnimported = true,
							staticcheck = false,
							semanticTokens = false,
							semanticTokenTypes = { keyword = true },
							semanticTokenModifiers = { definition = true },
							vulncheck = "Imports",
							gofumpt = true,
						},
					},
				},
				html = {},
				jinja_lsp = {},
				jsonls = {
					settings = {
						json = {
							schemas = require("schemastore").json.schemas(),
							validate = { enable = true },
						},
					},
				},
				jsonnet_ls = {},
				lua_ls = {
					-- cmd = {...},
					-- filetypes = { ...},
					-- capabilities = {},
					settings = {
						Lua = {
							workspace = {
								checkThirdParty = false,
							},
							codeLens = {
								enable = true,
							},
							completion = {
								callSnippet = "Replace",
							},
							doc = {
								privateName = { "^_" },
							},
							hint = {
								enable = true,
								setType = false,
								paramType = true,
								paramName = "Disable",
								semicolon = "Disable",
								arrayIndex = "Disable",
							},
						},
					},
				},
				marksman = {},
				ruff = {},
				tailwindcss = {
					filetypes = {
						"go",
						"templ",
					},
					settings = {
						tailwindCSS = {
							includeLanguages = {
								go = "html",
								templ = "html",
							},
							experimental = {
								classRegex = {
									{ "Class(?:es)?[({]([^)}]*)[)}]", '["`]([^"`]*)["`]' },
								},
							},
						},
					},
				},
				taplo = {},
				cssls = {},
				templ = {},
				tflint = {},
				ty = {},
				yamlls = {
					settings = {
						yaml = {
							schemaStore = {
								-- You must disable built-in schemaStore support if you want to use
								-- this plugin and its advanced options like `ignore`.
								enable = false,
								-- Avoid TypeError: Cannot read properties of undefined (reading 'length')
								url = "",
							},
							schemas = require("schemastore").yaml.schemas(),
						},
					},
				},
				postgres_lsp = {},
				gh_actions_ls = {
					filetypes = { "yaml.github" },
				},
			},
			-- This table contains config for all language servers that are *not* installed via Mason.
			-- Structure is identical to the mason table from above.
			others = {
				-- dartls = {},
			},
		}

		-- Ensure the servers and tools above are installed
		--
		-- To check the current status of installed tools and/or manually install
		-- other tools, you can run
		--    :Mason
		--
		-- You can press `g?` for help in this menu.
		--
		-- `mason` had to be setup earlier: to configure its options see the
		-- `dependencies` table for `nvim-lspconfig` above.
		--
		-- You can add other tools here that you want Mason to install
		-- for you, so that they are available from within Neovim.
		local ensure_installed = vim.tbl_keys(servers.mason or {})
		vim.list_extend(ensure_installed, {
			"actionlint",
			"ansible-lint",
			"black",
			"buf",
			"debugpy",
			"delve",
			"gofumpt",
			"goimports",
			"golangci-lint",
			"golines",
			"gotests",
			"gotestsum",
			"hadolint",
			"isort",
			"jq",
			"jsonlint",
			"markdown-toc",
			"markdownlint",
			"markdownlint-cli2",
			"mypy",
			"prettierd",
			"rustywind",
			"shellcheck",
			"sqlfluff",
			"staticcheck",
			"stylua",
			"systemdlint",
			"tfsec",
			"vale",
		})
		require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

		-- Either merge all additional server configs from the `servers.mason` and `servers.others` tables
		-- to the default language server configs as provided by nvim-lspconfig or
		-- define a custom server config that's unavailable on nvim-lspconfig.
		for server, config in pairs(vim.tbl_extend("keep", servers.mason, servers.others)) do
			if not vim.tbl_isempty(config) then
				vim.lsp.config(server, config)
			end
		end

		-- After configuring our language servers, we now enable them
		require("mason-lspconfig").setup({
			ensure_installed = {}, -- explicitly set to an empty table, populates installs via mason-tool-installer
			automatic_enable = true, -- automatically run vim.lsp.enable() for all servers that are installed via Mason
		})

		-- Manually run vim.lsp.enable for all language servers that are *not* installed via Mason
		if not vim.tbl_isempty(servers.others) then
			vim.lsp.enable(vim.tbl_keys(servers.others))
		end

		vim.diagnostic.config({
			-- disable virtual text
			-- virtual_text = false,
			-- show signs
			update_in_insert = true,
			underline = true,
			severity_sort = true,
			float = {
				focusable = false,
				style = "minimal",
				border = "rounded",
				source = "if_many",
				header = "",
				prefix = "",
			},
			signs = {
				text = {
					[vim.diagnostic.severity.ERROR] = " ",
					[vim.diagnostic.severity.WARN] = " ",
					[vim.diagnostic.severity.INFO] = " ",
					[vim.diagnostic.severity.HINT] = "󰠠 ",
				},
				texthl = {
					[vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
					[vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
					[vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
					[vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
				},
				numhl = {
					[vim.diagnostic.severity.ERROR] = "",
					[vim.diagnostic.severity.WARN] = "",
					[vim.diagnostic.severity.INFO] = "",
					[vim.diagnostic.severity.HINT] = "",
				},
			},
		})
	end,
}
