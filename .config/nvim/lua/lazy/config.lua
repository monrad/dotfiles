-- Setup Lazy plugins
require("lazy").setup({
  -- load plugins
  -- ui plugins
  require("lazy.plugins.ui.indent-blanklines"),
  require("lazy.plugins.ui.lualine"),
  require("lazy.plugins.ui.neo-tree"),
  require("lazy.plugins.ui.noice"),
  require("lazy.plugins.ui.oil"),
  require("lazy.plugins.ui.precognition"),
  require("lazy.plugins.ui.todo-comments"),
  require("lazy.plugins.ui.tokyonight"),
  -- base plugins
  require("lazy.plugins.base.arrow"),
  require("lazy.plugins.base.telescope"),
  require("lazy.plugins.base.undotree"),
  require("lazy.plugins.base.vim-sleuth"),
  require("lazy.plugins.base.which-key"),
  -- code plugins
  require("lazy.plugins.code.autocompletion"),
  require("lazy.plugins.code.autopairs"),
  require("lazy.plugins.code.conform"),
  require("lazy.plugins.code.debug"),
  require("lazy.plugins.code.lint"),
  require("lazy.plugins.code.lsp"),
  require("lazy.plugins.code.trouble"),
  -- YAML/JSON
  require("lazy.plugins.code.yaml.schemastore"),
  require("lazy.plugins.code.yaml.yaml-companion"),
  -- Treesitter
  require("lazy.plugins.code.treesitter.treesitter"),
  require("lazy.plugins.code.treesitter.textobject"),
  require("lazy.plugins.code.treesitter.autotag"),
  -- Lua
  require("lazy.plugins.code.lua.lazydev"),
  require("lazy.plugins.code.lua.luvit-meta"),
  -- Go
  require("lazy.plugins.code.go.goimplements"),
  require("lazy.plugins.code.go.gotests"),
  require("lazy.plugins.code.go.templ-goto-definition"),
  -- Markdown
  require("lazy.plugins.code.markdown.markdown-preview"),
  require("lazy.plugins.code.markdown.render-markdown"),
  -- Git
  require("lazy.plugins.code.git.gitsigns"),
  require("lazy.plugins.code.git.gitworktree"),
  -- Python
  require("lazy.plugins.code.python.python-venv-selector"),
  -- require "lazy.plugins.code.python.whichpy",
  -- Ansible
  require("lazy.plugins.code.ansible.nvim-ansible"),

  ui = {
    -- If you have a Nerd Font, set icons to an empty table which will use the
    -- default lazy.nvim defined Nerd Font icons otherwise define a unicode icons table
    icons = vim.g.have_nerd_font and {} or {
      cmd = "⌘",
      config = "🛠",
      event = "📅",
      ft = "📂",
      init = "⚙",
      keys = "🗝",
      plugin = "🔌",
      runtime = "💻",
      require = "🌙",
      source = "📄",
      start = "🚀",
      task = "📌",
      lazy = "💤 ",
    },
  },
})
