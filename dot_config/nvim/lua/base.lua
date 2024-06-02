-- Thanks to
-- https://scrapbox.io/vim-jp/boolean%E3%81%AA%E5%80%A4%E3%82%92%E8%BF%94%E3%81%99vim.fn%E3%81%AEwrapper_function
vim.bool_fn = setmetatable({}, {
   __index = function(_, key)
       return function(...)
           local v = vim.fn[key](...)
           if not v or v == 0 or v == "" then
               return false
           elseif type(v) == "table" and next(v) == nil then
               return false
           end
           return true
       end
   end,
})

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
vim.opt.wrap = true
vim.opt.path:append { '**' }
vim.opt.wildignore:append { '*/node_modules/*' }

-- Add asterisks in block comments
vim.opt.formatoptions:append { 'r' }

-- Disable Intro
vim.opt.shortmess:append("I")

-- clipboard
if vim.bool_fn.has('linux') then
  vim.opt.clipboard:append{'unnamedplus'}
end

-- ambiwidth
vim.fn.setcellwidths({
  {57520, 57523, 1}, -- lualineのセパレーター
  {9661, 9661, 2},   -- ▼▽
})

-- 初回ファイルを開いたときに，そのファイルのディレクトリにcdする

function vim.g.get_start_directory()
  if vim.fn.argc() > 0 then
    return vim.fn.fnamemodify(vim.fn.argv()[1], ":p:h")
  end
  return vim.fn.getcwd()
end
if vim.bool_fn.has("vim_starting") then
  vim.cmd.cd(vim.g.get_start_directory())
end
