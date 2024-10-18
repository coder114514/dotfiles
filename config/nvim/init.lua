local scriptpath = debug.getinfo(1, 'S').source:sub(2)
local scripthome = vim.fn.fnamemodify(scriptpath, ':h')

vim.opt.rtp:prepend(scripthome)
package.path = package.path .. ';' .. scripthome .. '/?.lua'

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

------------------------------------------------------------------------------
---- Make sure to setup `mapleader` and `maplocalleader` before
---- loading lazy.nvim so that mappings are correct.
---- This is also a good place to setup other settings (vim.opt)
------------------------------------------------------------------------------
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.keymap.set("x", "p", "P")

-- options

vim.opt.nu = true
vim.opt.rnu = true
vim.opt.scrolloff=5

vim.opt.hidden = false

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true

vim.opt.cursorline = true
vim.opt.listchars = { space = '·', nbsp = '⎵', tab = '▸-' }
vim.opt.list = true
vim.g.c_space_errors = 1 -- not working for some reason

vim.opt.swapfile = false
vim.opt.undofile = true

vim.opt.isfname:append("@-@")

-- https://vim-jp.org/vimdoc-en/indent.html#cinoptions-values
vim.opt.cinoptions = "l1N-sE-st0Lsg0"

vim.api.nvim_create_user_command('RemoveTrailingWs', function ()
    local saved = vim.fn.winsaveview()
    vim.cmd("%s/\\s\\+$//e")
    vim.fn.winrestview(saved)
end, {})

-- restore cusor style on quit
vim.api.nvim_create_autocmd({'VimLeave'}, {
    pattern = '*',
    callback = function ()
        vim.opt.guicursor = ""
        vim.fn.chansend(vim.v.stderr, "\x1b[ q")
    end,
})

-- remember last edit position in files
vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = "*",
  callback = function()
    local last_pos = vim.fn.line("'\"")
    if last_pos > 1 and last_pos <= vim.fn.line("$") then
      vim.api.nvim_exec('normal! g`"', false)
    end
  end,
})

------------------------------------------------------------------------------
---- lazy options
------------------------------------------------------------------------------
local opts = {
    root = vim.fn.stdpath 'data' .. '/lazy',
    performance = {
        rtp = {
            reset = false
        }
    },
    ui = {
        icons = vim.g.have_nerd_font and {} or {
            cmd = '⌘',
            config = '🛠',
            event = '📅',
            ft = '📂',
            init = '⚙',
            keys = '🗝',
            plugin = '🔌',
            runtime = '💻',
            require = '🌙',
            source = '📄',
            start = '🚀',
            task = '📌',
            lazy = '💤 ',
        },
    },
    install = { colorscheme = { "gruvbox", "habamax" } },
}

------------------------------------------------------------------------------
---- Setup lazy.nvim
------------------------------------------------------------------------------
require("lazy").setup("plugins", opts)
