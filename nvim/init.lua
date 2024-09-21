---- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.runtimepath:prepend(lazypath)

---- Make sure to setup `mapleader` and `maplocalleader` before
---- loading lazy.nvim so that mappings are correct.
---- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- options

vim.opt.nu = true
vim.opt.hidden = false

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true

vim.opt.cursorline = true
vim.opt.listchars = { space = '·', nbsp = '⎵', tab = '▸-' }

vim.opt.swapfile = false
vim.opt.undofile = true

vim.opt.isfname:append("@-@")

-- https://vim-jp.org/vimdoc-en/indent.html#cinoptions-values
vim.opt.cinoptions = "l1N-sE-st0Lsg0"

-- restore cusor style on quit
vim.api.nvim_create_autocmd({'VimLeave'}, {
    pattern = '*',
    callback = function ()
        vim.opt.guicursor = ""
        vim.fn.chansend(vim.v.stderr, "\x1b[ q")
    end,
})

---- Setup lazy.nvim
require("lazy").setup({
    spec = {
        -- import your plugins
        { import = "plugins" },
    },
    -- Configure any other settings here. See the documentation for more details.
    -- colorscheme that will be used when installing plugins.
    install = { colorscheme = { "gruvbox", "habamax" } },
})
