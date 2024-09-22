return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local function get_schema()
			local schema = require("yaml-companion").get_buf_schema(0)
			if schema.result[1].name == "none" then
				return ""
			end
			return schema.result[1].name
		end
		require("lualine").setup({
			sections = {
				lualine_x = {
					get_schema,
					"encoding",
					"fileformat",
					"filetype",
					{
						require("noice").api.status.message.get_hl,
						cond = require("noice").api.status.message.has,
					},
					{
						require("noice").api.status.mode.get,
						cond = require("noice").api.status.mode.has,
						color = { fg = "#ff9e64" },
					},
					{
						require("noice").api.status.search.get,
						cond = require("noice").api.status.search.has,
						color = { fg = "#ff9e64" },
					},
				},
			},
		})
	end,
}
