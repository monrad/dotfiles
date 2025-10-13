-- Autocompletion
return {
	"saghen/blink.cmp",
	event = "VimEnter",
	version = "1.*",
	dependencies = {
		-- Snippet Engine
		{
			"L3MON4D3/LuaSnip",
			version = "2.*",
			build = (function()
				-- Build Step is needed for regex support in snippets.
				-- This step is not supported in many windows environments.
				-- Remove the below condition to re-enable on windows.
				if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
					return
				end
				return "make install_jsregexp"
			end)(),
			dependencies = {
				-- `friendly-snippets` contains a variety of premade snippets.
				--    See the README about individual language/framework/plugin snippets:
				--    https://github.com/rafamadriz/friendly-snippets
				{
					"rafamadriz/friendly-snippets",
					config = function()
						require("luasnip.loaders.from_vscode").lazy_load()
					end,
				},
			},
			opts = {},
		},
		{
			"Kaiser-Yang/blink-cmp-git",
			dependencies = { "nvim-lua/plenary.nvim" },
		},
		{ "samiulsami/cmp-go-deep", dependencies = { "kkharji/sqlite.lua" } },
		{ "saghen/blink.compat" },
		"onsails/lspkind.nvim",
		"ribru17/blink-cmp-spell",
		"folke/lazydev.nvim",
		"disrupted/blink-cmp-conventional-commits",
		{
			"bydlw98/blink-cmp-sshconfig",
			build = "make",
		},
	},
	--- @module 'blink.cmp'
	--- @type blink.cmp.Config
	opts = {
		keymap = {
			-- 'default' (recommended) for mappings similar to built-in completions
			--   <c-y> to accept ([y]es) the completion.
			--    This will auto-import if your LSP supports it.
			--    This will expand snippets if the LSP sent a snippet.
			-- 'super-tab' for tab to accept
			-- 'enter' for enter to accept
			-- 'none' for no mappings
			--
			-- For an understanding of why the 'default' preset is recommended,
			-- you will need to read `:help ins-completion`
			--
			-- No, but seriously. Please read `:help ins-completion`, it is really good!
			--
			-- All presets have the following mappings:
			-- <tab>/<s-tab>: move to right/left of your snippet expansion
			-- <c-space>: Open menu or open docs if already open
			-- <c-n>/<c-p> or <up>/<down>: Select next/previous item
			-- <c-e>: Hide menu
			-- <c-k>: Toggle signature help
			--
			-- See :h blink-cmp-config-keymap for defining your own keymap
			preset = "default",
			-- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:

			--    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
			["<Tab>"] = {
				"snippet_forward",
				function() -- sidekick next edit suggestion
					return require("sidekick").nes_jump_or_apply()
				end,
				function() -- if you are using Neovim's native inline completions
					return vim.lsp.inline_completion.get()
				end,
				"fallback",
			},
		},

		appearance = {
			-- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
			-- Adjusts spacing to ensure icons are aligned
			nerd_font_variant = "mono",
		},

		sources = {
			default = {
				"buffer",
				"spell",
				"git",
				"lsp",
				"go_deep",
				"path",
				"snippets",
				"lazydev",
				"conventional_commits",
				"sshconfig",
			},
			providers = {
				lazydev = { module = "lazydev.integrations.blink", score_offset = 100 },
				git = {
					module = "blink-cmp-git",
					name = "Git",
					-- only enable this source when filetype is gitcommit, markdown, or 'octo'
					enabled = function()
						return vim.tbl_contains({ "octo", "gitcommit", "markdown" }, vim.bo.filetype)
					end,
					--- @module 'blink-cmp-git'
					--- @type blink-cmp-git.Options
					opts = {
						-- options for the blink-cmp-git
					},
				},
				spell = {
					name = "Spell",
					module = "blink-cmp-spell",
					opts = {
						-- EXAMPLE: Only enable source in `@spell` captures, and disable it
						-- in `@nospell` captures.
						enable_in_context = function()
							local curpos = vim.api.nvim_win_get_cursor(0)
							local captures = vim.treesitter.get_captures_at_pos(0, curpos[1] - 1, curpos[2] - 1)
							local in_spell_capture = false
							for _, cap in ipairs(captures) do
								if cap.capture == "spell" then
									in_spell_capture = true
								elseif cap.capture == "nospell" then
									return false
								end
							end
							return in_spell_capture
						end,
					},
				},
				go_deep = {
					name = "go_deep",
					module = "blink.compat.source",
					min_keyword_length = 3,
					max_items = 5,
					---@module "cmp_go_deep"
					---@type cmp_go_deep.Options
					opts = {
						filetypes = { "go", "templ" },
						-- See below for configuration options
					},
				},
				conventional_commits = {
					name = "Conventional Commits",
					module = "blink-cmp-conventional-commits",
					enabled = function()
						return vim.bo.filetype == "gitcommit"
					end,
					---@module 'blink-cmp-conventional-commits'
					---@type blink-cmp-conventional-commits.Options
					opts = {}, -- none so far
				},
				sshconfig = {
					name = "SshConfig",
					module = "blink-cmp-sshconfig",
					enabled = function()
						return vim.bo.filetype == "sshconfig"
					end,
				},
			},
			per_filetype = {
				codecompanion = { "codecompanion" },
			},
		},

		snippets = { preset = "luasnip" },

		-- Blink.cmp includes an optional, recommended rust fuzzy matcher,
		-- which automatically downloads a prebuilt binary when enabled.
		--
		-- By default, we use the Lua implementation instead, but you may enable
		-- the rust implementation via `'prefer_rust_with_warning'`
		--
		-- See :h blink-cmp-config-fuzzy for more information
		fuzzy = {
			implementation = "prefer_rust_with_warning",
			sorts = {
				function(a, b)
					local sort = require("blink.cmp.fuzzy.sort")
					if a.source_id == "spell" and b.source_id == "spell" then
						return sort.label(a, b)
					end
				end,
				-- This is the normal default order, which we fall back to
				"score",
				"kind",
				"label",
			},
		},

		-- Shows a signature help window while you type arguments for a function
		signature = { enabled = true },

		completion = {
			menu = {
				draw = {
					columns = {
						{ "kind_icon", "label", "label_description", gap = 1 },
						{ "kind", "source_name", gap = 1 },
					},
					-- columns = {
					-- 	{ "kind_icon", "kind" },
					-- 	{ "label", "label_description", gap = 1 },
					-- },
					-- columns = { { "label", "label_description", gap = 1 }, { "kind_icon", "kind" } },
					components = {
						kind_icon = {
							text = function(ctx)
								local icon = ctx.kind_icon
								if vim.tbl_contains({ "Path" }, ctx.source_name) then
									local dev_icon, _ = require("nvim-web-devicons").get_icon(ctx.label)
									if dev_icon then
										icon = dev_icon
									end
								else
									icon = require("lspkind").symbolic(ctx.kind, {
										mode = "symbol",
									})
								end

								return icon .. ctx.icon_gap
							end,

							-- Optionally, use the highlight groups from nvim-web-devicons
							-- You can also add the same function for `kind.highlight` if you want to
							-- keep the highlight groups in sync with the icons.
							highlight = function(ctx)
								local hl = ctx.kind_hl
								if vim.tbl_contains({ "Path" }, ctx.source_name) then
									local dev_icon, dev_hl = require("nvim-web-devicons").get_icon(ctx.label)
									if dev_icon then
										hl = dev_hl
									end
								end
								return hl
							end,
						},
						label_description = {
							width = { max = 50 },
							text = function(ctx)
								return ctx.label_description ~= "" and ctx.label_description or ctx.item.detail
							end,
						},
					},
				},
			},
		},
	},
}
