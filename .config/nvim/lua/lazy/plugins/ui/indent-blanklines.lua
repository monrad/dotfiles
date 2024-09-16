-- Add indentation guides even on blank lines
return {
  "lukas-reineke/indent-blankline.nvim",
  -- Enable `lukas-reineke/indent-blankline.nvim`
  -- See `:help ibl`
  main = "ibl",
  event = { "BufReadPre", "BufNewFile" },
  opts = {},
}
