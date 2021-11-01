vim.cmd[[colorscheme tokyonight]]

-- Set line numbers
vim.wo.number = true

-- Set 90 char line limit
vim.wo.colorcolumn = '90'

-- Insert spaces when you tab
vim.o.expandtab = true

-- Set number of spaces inserted to 4
vim.o.tabstop = 4
vim.o.shiftwidth = 4

-- Case insensitive searching unless /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- TODO: Not sure the difference between these two settings
vim.o.smartindent = true
vim.o.autoindent = true

-- Make some concessions towards usability (ewwww)
vim.o.mouse = 'a'

-- TODO: what does this do?
vim.cmd[[filetype plugin indent on]]
vim.o.syntax = 'on'
vim.o.hidden = true
vim.o.backspace='indent,eol,start'

-- give more space for command output
vim.o.cmdheight = 2

-- open vertical splits to the right of the current buffer (:vsp)
vim.o.splitright = true

-- open horizontal splits beneath the current buffer (:sp) 
vim.o.splitbelow = true

-- TODO: what does this do?
vim.wo.signcolumn = 'number'

-- TODO: what does this do?
vim.o.termguicolors = true

-- required for compe
-- TODO: explain
vim.o.completeopt = "menuone,noselect"
