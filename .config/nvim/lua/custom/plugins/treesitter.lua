return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      -- add your own config options here
      ensure_installed = {
        "arduino",
        "bash",
        "c",
        "csv",
        "dockerfile",
        "git_config",
        "gitignore",
        "go",
        "html",
        "lua",
        "markdown",
        "sql",
        "ssh_config",
        "templ",
        "terraform",
        "toml",
        "vim",
        "vimdoc",
        "yaml",
      },
      -- Autoinstall languages that are not installed
      auto_install = true,
      highlight = {
        enable = true,
        -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
        --  If you are experiencing weird indenting issues, add the language to
        --  the list of additional_vim_regex_highlighting and disabled languages for indent.
        additional_vim_regex_highlighting = { "ruby" },
      },
      indent = { enable = true, disable = { "ruby" } },
    },
  },
}
