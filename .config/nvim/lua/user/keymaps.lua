-- Shorten function name
local keymap = vim.keymap.set
-- Silent keymap option
local opts = { silent = true }

--Remap space as leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Disable arrow keys for navigation
keymap('', '<up>', '<nop>', opts)
keymap('', '<down>', '<nop>', opts)
keymap('', '<left>', '<nop>', opts)
keymap('', '<right>', '<nop>', opts)

-- File explore
keymap('n', '<leader>pv', ':Ex<CR>', opts)
