vim.cmd("autocmd!")

vim.scriptencoding = 'utf-8'
vim.opt.encoding = 'utf-8'
vim.opt.fileencoding = 'utf-8'


-- display
vim.opt.number = true
vim.opt.title = true
vim.opt.scrolloff = 10
vim.opt.inccommand = 'split'

-- indent
vim.opt.smartindent = true

-- search
vim.opt.showcmd = true
vim.opt.cmdheight = 1

-- file
vim.opt.backup = false
vim.opt.backupskip = { '/tmp/*', '/private/tmp/*' }

-- coding style
vim.opt.expandtab = true
vim.opt.ignorecase = true
vim.opt.breakindent = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2

-- others
vim.opt.shell = 'zsh'
vim.opt.wrap = false
vim.opt.path:append { '**' }
vim.opt.wildignore:append { '*/node_modules/*' }

-- Add asterisks in block comments
vim.opt.formatoptions:append { 'r' }
