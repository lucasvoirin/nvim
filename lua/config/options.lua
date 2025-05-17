vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

function _G.CurrentDirName()
  return vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
end

vim.opt.title = true
-- vim.opt.titlestring="NEOVIM"
vim.o.titlestring = "NEOVIM ⋅ %{v:lua.CurrentDirName()}"

vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.textwidth = 0
vim.opt.colorcolumn = ""

vim.opt.number = true
vim.opt.cursorline = true

vim.opt.shiftwidth = 2

vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.clipboard = "unnamedplus"

vim.opt.scrolloff = 10
