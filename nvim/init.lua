require("config.lazy")
require("config.remap")
require("config.set")

local vimrc = vim.fn.stdpath('config') .. '/legacy-vimrc.vim'
vim.cmd.source(vimrc)
