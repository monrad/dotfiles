return {
  "nvim-neo-tree/neo-tree.nvim",
  version = "*",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
    "MunifTanjim/nui.nvim",
  },
  config = function()
    require("neo-tree").setup {}
  end,
  -- Neotree keymaps
  --  vim.keymap.set("n", "<C-b>", "<Cmd>Neotree toggle<CR>"),
}
