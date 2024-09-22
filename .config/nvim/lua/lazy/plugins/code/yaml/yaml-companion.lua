return {
	"someone-stole-my-name/yaml-companion.nvim",
	requires = {
		{ "neovim/nvim-lspconfig" },
		{ "nvim-lua/plenary.nvim" },
		{ "nvim-telescope/telescope.nvim" },
	},
	ft = "yaml",
	config = function()
		local cfg = require("yaml-companion").setup({
			lspconfig = {
				settings = {
					yaml = {
						validate = true,
						schemaStore = {
							enable = false,
							url = "",
						},
						schemas = require("schemastore").yaml.schemas(),
					},
				},
			},
		})
		require("lspconfig")["yamlls"].setup(cfg)
		require("telescope").load_extension("yaml_schema")
	end,
}
