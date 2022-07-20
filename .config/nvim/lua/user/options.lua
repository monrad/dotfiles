local options = {
  -- completeopt = { "menuone", "noselect" }, -- mostly just for cmp
  -- conceallevel = 0,                        -- so that `` is visible in markdown files
  -- guifont = "monospace:h17",               -- the font used in graphical neovim applications
  -- numberwidth = 4,                         -- set number column width to 2 {default 4}
  -- pumheight = 10,                          -- pop up menu height
  -- scrolloff = 8,                           -- is one of my fav
  -- shiftwidth = 2,                          -- the number of spaces inserted for each indentation
  -- showmode = false,                        -- we don't need to see things like -- INSERT -- anymore
  -- showtabline = 2,                         -- always show tabs
  -- sidescrolloff = 8,
  -- splitbelow = true,                       -- force all horizontal splits to go below current window
  -- splitright = true,                       -- force all vertical splits to go to the right of current window
  -- tabstop = 2,                             -- insert 2 spaces for a tab
  -- timeoutlen = 100,                        -- time to wait for a mapped sequence to complete (in milliseconds)
  -- undofile = true,                         -- enable persistent undo
  -- updatetime = 300,                        -- faster completion (4000ms default)
  -- wrap = false,                            -- display lines as one long line
  backup = false,                          -- creates a backup file
  clipboard = "unnamed",                   -- don't use the system clipboard, change to unnamedplus to allow neovim to access the system clipboard
  cmdheight = 2,                           -- more space in the neovim command line for displaying messages
  cursorline = true,                       -- highlight the current line
  expandtab = true,                        -- convert tabs to spaces
  fileencoding = "utf-8",                  -- the encoding written to a file
  hlsearch = true,                         -- highlight all matches on previous search pattern
  ignorecase = true,                       -- ignore case in search patterns
  mouse = "a",                             -- allow the mouse to be used in neovim
  number = true,                           -- set numbered lines
  relativenumber = true,                   -- set relative numbered lines
  signcolumn = "yes",                      -- always show the sign column, otherwise it would shift the text each time
  smartcase = true,                        -- smart case
  smartindent = true,                      -- make indenting smarter again
  swapfile = false,                        -- creates a swapfile
  termguicolors = true,                    -- set term gui colors (most terminals support this)
  writebackup = false,                     -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
}

-- vim.opt.shortmess:append "c"

for k, v in pairs(options) do
  vim.opt[k] = v
end
