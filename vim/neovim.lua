-----------------------------------------------------------------------------
---- Configurable Variables before loading this script:
---    vim.g.have_nerd_font
----   vim.g.lazyroot
-----------------------------------------------------------------------------

local scriptpath = debug.getinfo(1, 'S').source:sub(2)
local scripthome = vim.fn.fnamemodify(scriptpath, ':h')

package.path = package.path .. ';' .. scripthome .. '/?.lua'

vim.cmd.source(scripthome .. "/vim.vim")

if not vim.g.neovide then
    -- https://www.reddit.com/r/neovim/comments/zzs7eq/using_alacritty_but_no_transparency/
    local highlights = {
        'Normal',
        'LineNr',
        'Folded',
        'NonText',
        'SpecialKey',
        'VertSplit',
        'SignColumn',
        'EndOfBuffer',
        'TablineFill', -- this is specific to how I like my tabline to look like
    }
    for _, name in pairs(highlights) do vim.cmd.highlight(name .. ' guibg=none ctermbg=none') end
end

vim.opt.undofile = true -- for undo tree

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
local opts = {
    root = lazyroot,
    performance = {
        reset_packpath = false,
        rtp = {
            reset = false,
        },
    },
    ui = {
        icons = vim.g.have_nerd_font and {} or {
            cmd = '', config = '', event = '', ft = '', init = '', keys = '', plugin = '',
            runtime = '', require = '', source = '', start = '', task = '', lazy = ''
        },
    },
    rocks = {
        enabled = false
    },
}

------------------------------------------------------------------------------
---- Setup lazy.nvim
------------------------------------------------------------------------------
require("lazy").setup("plugins", opts)
