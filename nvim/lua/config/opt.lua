vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop=4
vim.opt.shiftwidth=4
vim.opt.expandtab=true

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true

vim.opt.cursorline = true
vim.opt.listchars = { space = '·', nbsp = '⎵', tab = '▸-' }
vim.opt.list = true

vim.opt.swapfile = false
vim.opt.undodir = vim.fn.stdpath('data') .. "/undodir"
vim.opt.undofile = true

vim.opt.scrolloff = 8
vim.opt.isfname:append("@-@")

vim.api.nvim_create_autocmd({'VimLeave'}, { -- restore cusor style on quit
    pattern = '*',
    callback = function ()
        vim.opt.guicursor = "",
        vim.fn.chansend(vim.v.stderr, "\x1b[ q")
    end,
})

-- https://vim-jp.org/vimdoc-en/indent.html#cinoptions-values
vim.opt.cinoptions = "l1N-sE-st0Lsg0"
vim.g.c_space_erros = 1
