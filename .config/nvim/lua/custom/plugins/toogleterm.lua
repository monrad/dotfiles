return {
  "akinsho/toggleterm.nvim",
  version = "*",
  config = function()
    require("toggleterm").setup {
      open_mapping = "<leader>tt",
      direction = "float",
    }
  end,
  vim.keymap.set("n", "<leader>tf", ":ToggleTerm direction=float<CR>", { desc = "[T]oggleTerm [F]loat" }),
  vim.keymap.set(
    "n",
    "<leader>th",
    ":ToggleTerm direction=horizontal size=20<CR>",
    { desc = "[T]oggleTerm [H]orizontal" }
  ),
}
