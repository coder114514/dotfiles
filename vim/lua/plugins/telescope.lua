local function config_dir()
    local path = vim.fn.fnamemodify(debug.getinfo(2, 'S').source:sub(2), ':p:h:h:h')
    local is_windows = package.config:sub(1, 1) == '\\'
    if is_windows then
        path = path:gsub("/", "\\")
    end
    return path
end

return {
    "nvim-telescope/telescope.nvim",
    lazy = false,
    dependencies = {
        'nvim-lua/plenary.nvim',
    },
    config = function()
        local builtin = require('telescope.builtin')
        vim.keymap.set('n', '<leader>sh',       builtin.help_tags,   { desc = '[S]earch [H]elp' })
        vim.keymap.set('n', '<leader>sk',       builtin.keymaps,     { desc = '[S]earch [K]eymaps' })
        vim.keymap.set('n', '<leader>sf',       builtin.find_files,  { desc = '[S]earch [F]iles' })
        vim.keymap.set('n', '<leader>ss',       builtin.builtin,     { desc = '[S]earch [S]elect Telescope' })
        vim.keymap.set('n', '<leader>sw',       builtin.grep_string, { desc = '[S]earch current [W]ord' })
        vim.keymap.set('n', '<leader>sg',       builtin.live_grep,   { desc = '[S]earch by [G]rep' })
        vim.keymap.set('n', '<leader>sd',       builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
        vim.keymap.set('n', '<leader>sr',       builtin.resume,      { desc = '[S]earch [R]esume' })
        vim.keymap.set('n', '<leader>s.',       builtin.oldfiles,    { desc = '[S]earch Recent Files ("." for repeat)' })
        vim.keymap.set('n', '<leader><leader>', builtin.buffers,     { desc = '[ ] Find existing buffers' })

        -- Slightly advanced example of overriding default behavior and theme
        vim.keymap.set('n', '<leader>/', function()
            -- You can pass additional configuration to Telescope to change the theme, layout, etc.
            builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
                winblend = 10,
                previewer = false,
            })
        end, { desc = '[/] Fuzzily search in current buffer' })

        -- It's also possible to pass additional configuration options.
        --  See `:help telescope.builtin.live_grep()` for information about particular keys
        vim.keymap.set('n', '<leader>s/', function()
            builtin.live_grep {
                grep_open_files = true,
                prompt_title = 'Live Grep in Open Files',
            }
        end, { desc = '[S]earch [/] in Open Files' })

        -- Shortcut for searching your Neovim configuration files
        vim.keymap.set('n', '<leader>sn', function()
            builtin.find_files { cwd = vim.fn.stdpath 'config'  }
        end, { desc = '[S]earch [N]eovim files' })

        vim.keymap.set('n', '<leader>sc', function()
            builtin.find_files { cwd = config_dir(), file_ignore_patterns = { "^pack/", "^pack\\"  } }
        end, { desc = '[S]earch [C]onfig files' })

        -- Replace some default LSP shortcuts with those of telescope and add better descriptions
        vim.keymap.set('n',          'grn',        vim.lsp.buf.rename,                             { desc = 'LSP: Re[n]ame' })
        vim.keymap.set({ 'n', 'x' }, 'gra',        vim.lsp.buf.code_action,                        { desc = 'LSP: Code [A]ction' })
        vim.keymap.set('n',          'grr',        builtin.lsp_references,                         { desc = 'LSP: Goto [R]eferences' })
        vim.keymap.set('n',          'gri',        builtin.lsp_implementations,                    { desc = 'LSP: Goto [I]mplementation' })
        vim.keymap.set('n',          'grd',        builtin.lsp_definitions,                        { desc = 'LSP: Goto [D]efinition' })
        vim.keymap.set('n',          'grD',        vim.lsp.buf.declaration,                        { desc = 'LSP: Goto [D]eclaration' })
        vim.keymap.set('n',          'grt',        builtin.lsp_type_definitions,                   { desc = 'LSP: [T]ype Definition' })
        vim.keymap.set('n',          'gO',         builtin.lsp_document_symbols,                   { desc = 'LSP: [O]pen Document Symbols' })
        vim.keymap.set('n',          'gW',         builtin.lsp_dynamic_workspace_symbols,          { desc = 'LSP: Open [W]orkspace Symbols' })
        vim.keymap.set('n',          '<leader>th', function() print("Inlay Hints Not Loaded") end, { desc = 'LSP: [T]oggle Inlay [H]ints' })
    end,
}
