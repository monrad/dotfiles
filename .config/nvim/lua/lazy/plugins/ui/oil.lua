return {
  "stevearc/oil.nvim",
  opts = {
    view_options = {
      show_hidden = true,
    },
  },
  dependencies = { "nvim-tree/nvim-web-devicons" },
  -- Keys
  vim.keymap.set("n", "<leader>o", "<cmd>Oil<cr>", { desc = "browse files/dirs with [o]il" }),
}
