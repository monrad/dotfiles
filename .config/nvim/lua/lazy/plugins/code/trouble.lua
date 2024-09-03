return {
  "folke/trouble.nvim",
  opts = {}, -- for default options, refer to the configuration section for custom setup.
  cmd = "Trouble",
  keys = {
    {
      "<leader>wd",
      "<cmd>Trouble diagnostics toggle<cr>",
      desc = "[w]orkspace [d]iagnostics",
    },
    {
      "<leader>wt",
      "<cmd>Trouble todo toggle win.position=right win.size=100<cr>",
      desc = "[w]orkspace [t]odo",
    },
    {
      "<leader>dd",
      "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
      desc = "[d]ocument buffer [d]iagnostics",
    },
    {
      "<leader>ds",
      "<cmd>Trouble symbols toggle win.position=right win.size=100<cr>",
      desc = "[d]ocument [s]ymbols",
    },
    {
      "<leader>cd",
      "<cmd>Trouble lsp toggle focus=false win.position=right win.size=100<cr>",
      desc = "[c]ode LSP [d]efintions/references/...",
    },
    {
      "<leader>q",
      "<cmd>Trouble qflist toggle<cr>",
      desc = "Open diagnostic [q]uickfix list",
    },
  },
}
