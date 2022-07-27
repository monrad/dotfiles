-- vim.opt.completeopt = { "menuone" "noselect" } -- mostly just for cmp
-- vim.opt.conceallevel = 0                        -- so that `` is visible in markdown files
-- vim.opt.guifont = "monospace:h17"               -- the font used in graphical neovim applications
-- vim.opt.numberwidth = 4                         -- set number column width to 2 {default 4}
-- vim.opt.pumheight = 10                          -- pop up menu height
-- vim.opt.shiftwidth = 2                          -- the number of spaces inserted for each indentation
-- vim.opt.showmode = false                        -- we don't need to see things like -- INSERT -- anymore
-- vim.opt.showtabline = 2                         -- always show tabs
-- vim.opt.splitbelow = true                       -- force all horizontal splits to go below current window
-- vim.opt.splitright = true                       -- force all vertical splits to go to the right of current window
-- vim.opt.tabstop = 2                             -- insert 2 spaces for a tab
-- vim.opt.timeoutlen = 100                        -- time to wait for a mapped sequence to complete (in milliseconds)
-- vim.opt.undofile = true                         -- enable persistent undo
-- vim.opt.wrap = false                            -- display lines as one long line
vim.opt.backup = false -- creates a backup file
vim.opt.clipboard = "unnamed" -- don't use the system clipboard change to unnamedplus to allow neovim to access the system clipboard
vim.opt.cmdheight = 2 -- more space in the neovim command line for displaying messages
vim.opt.cursorline = true -- highlight the current line
vim.opt.expandtab = true -- convert tabs to spaces
vim.opt.fileencoding = "utf-8" -- the encoding written to a file
vim.opt.hlsearch = true -- highlight all matches on previous search pattern
vim.opt.ignorecase = true -- ignore case in search patterns
vim.opt.mouse = "a" -- allow the mouse to be used in neovim
vim.opt.number = true -- set numbered lines
vim.opt.relativenumber = true -- set relative numbered lines
vim.opt.scrolloff = 8 -- don't scroll all the way down 
vim.opt.sidescrolloff = 8 -- don't scroll all the way to the side
vim.opt.signcolumn = "yes" -- always show the sign column otherwise it would shift the text each time
vim.opt.smartcase = true -- smart case
vim.opt.smartindent = true -- make indenting smarter again
vim.opt.swapfile = false -- creates a swapfile
vim.opt.termguicolors = true -- set term gui colors (most terminals support this)
vim.opt.updatetime = 50 -- faster completion (4000ms default)
vim.opt.writebackup = false -- if a file is being edited by another program (or was written to file while editing with another program) it is not allowed to be edited

-- vim.opt.shortmess:append "c"

