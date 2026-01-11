return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	lazy = false,
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter").setup({
			install_dir = vim.fn.stdpath("data") .. "/site",
		})

		local parsers = {
			"arduino",
			"awk",
			"bash",
			"c",
			"css",
			"csv",
			"diff",
			"dockerfile",
			"dot",
			"editorconfig",
			"git_config",
			"git_rebase",
			"gitattributes",
			"gitcommit",
			"gitignore",
			"gnuplot",
			"go",
			"gomod",
			"gosum",
			"gotmpl",
			"gowork",
			"gpg",
			"graphql",
			"hcl",
			"helm",
			"html",
			"http",
			"ini",
			"javascript",
			"jinja",
			"jinja_inline",
			"jq",
			"jsdoc",
			"json",
			"json",
			"json5",
			"jsonnet",
			"latex",
			"lua",
			"make",
			"markdown",
			"markdown_inline",
			"mermaid",
			"nginx",
			"python",
			"query",
			"regex",
			"requirements",
			"ruby",
			"rust",
			"scss",
			"sql",
			"ssh_config",
			"templ",
			"terraform",
			"tmux",
			"toml",
			"typescript",
			"vim",
			"vimdoc",
			"xml",
			"yaml",
			"yang",
			"zsh",
		}

		vim.api.nvim_create_autocmd("User", {
			pattern = "LazyDone",
			once = true,
			callback = function()
				require("nvim-treesitter").install(parsers)
			end,
		})

		local augroup = vim.api.nvim_create_augroup("myconfig.treesitter", { clear = true })
		vim.api.nvim_create_autocmd("FileType", {
			group = augroup,
			pattern = { "*" },
			callback = function(event)
				local filetype = event.match
				local lang = vim.treesitter.language.get_lang(filetype)
				local is_installed, error = vim.treesitter.language.add(lang)

				if not is_installed then
					local available_langs = require("nvim-treesitter").get_available()
					local is_available = vim.tbl_contains(available_langs, lang)

					if is_available then
						vim.notify("Installing treesitter parser for " .. lang, vim.log.levels.INFO)
						require("nvim-treesitter").install({ lang }):wait(30 * 1000)
					end
				end

				local ok, _ = pcall(vim.treesitter.start, event.buf, lang)
				if not ok then
					return
				end

				vim.bo[event.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
				vim.wo[0][0].foldmethod = "expr"
			end,
		})
		-- Install Cedar treesitter parser
		vim.api.nvim_create_autocmd("User", {
			pattern = "TSUpdate",
			callback = function()
				require("nvim-treesitter.parsers").cedar = {
					install_info = {
						url = "https://github.com/DuskSystems/tree-sitter-cedar",
						branch = "main",
						location = "cedar",
						queries = "cedar/queries/",
					},
				}
			end,
		})
		-- Install Cedarschema treesitter parser
		vim.api.nvim_create_autocmd("User", {
			pattern = "TSUpdate",
			callback = function()
				require("nvim-treesitter.parsers").cedarschema = {
					install_info = {
						url = "https://github.com/DuskSystems/tree-sitter-cedar",
						branch = "main",
						location = "cedarschema",
						queries = "cedarschema/queries/",
					},
				}
			end,
		})
	end,
}
