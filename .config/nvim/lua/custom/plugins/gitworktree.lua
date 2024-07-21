return {
  "ThePrimeagen/git-worktree.nvim",
  version = "*",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    require("git-worktree").setup {}
  end,
  vim.keymap.set("n", "<leader>gwl", ":Telescope git_worktree git_worktree<CR>", { desc = "[g]it [w]orktree [l]ist" }),
  vim.keymap.set(
    "n",
    "<leader>gws",
    ":Telescope git_worktree git_worktree<CR>",
    { desc = "[g]it [w]orktree [s]witch" }
  ),
  vim.keymap.set(
    "n",
    "<leader>gwc",
    ":Telescope git_worktree create_git_worktree<CR>",
    { desc = "[g]it [w]orktree [c]reate" }
  ),
}
