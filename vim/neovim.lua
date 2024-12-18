-----------------------------------------------------------------------------
---- Configurable Variables before loading this script:
---    vim.g.have_nerd_font
----   vim.g.lazyroot
---    vim.g.lazyspec
-----------------------------------------------------------------------------

local scriptpath = debug.getinfo(1, 'S').source:sub(2)
local scripthome = vim.fn.fnamemodify(scriptpath, ':h')

package.path = package.path .. ';' .. scripthome .. '/?.lua'

vim.cmd.source(scripthome .. "/vim.vim")

------------------------------------------------------------------------------
---- Bootstrap lazy.nvim
------------------------------------------------------------------------------
local lazyroot = vim.g.lazyroot or vim.fn.stdpath "data" .. "/lazy"
local lazypath = lazyroot .. "/lazy.nvim"
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
---- lazy options
------------------------------------------------------------------------------
local spec = vim.g.lazyspec or {}
spec["import"] = "plugins"

local opts = {
    root = lazyroot,
    spec = spec,
    performance = {
        rtp = {
            reset = false
        }
    },
    ui = {
        icons = vim.g.have_nerd_font and {} or {
            cmd = '', config = '', event = '', ft = '', init = '', keys = '', plugin = '', runtime = '', require = '', source = '', start = '', task = '', lazy = ''
        },
    },
    rocks = {
        enabled = false
    },
    install = {
        colorscheme = { "gruvbox", "habamax" }
    },
}

------------------------------------------------------------------------------
---- Setup lazy.nvim
------------------------------------------------------------------------------
require("lazy").setup(opts)
