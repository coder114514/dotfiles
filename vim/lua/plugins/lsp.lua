return {
    -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
    -- used for completion, annotations and signatures of Neovim APIs
    {
        'folke/lazydev.nvim',
        ft = 'lua',
        dependencies = {
            { 'Bilal2453/luvit-meta', lazy = true },
            { 'LelouchHe/xmake-luals-addon', lazy = true },
        },
        opts = {
            library = {
                { path = 'luvit-meta/library', words = { 'vim%.uv' } },
                { path = "xmake-luals-addon/library", files = { "xmake.lua" } },
            },
        },
    },

    -- Autocompletion
    {
        'hrsh7th/nvim-cmp',
        event = 'InsertEnter',
        dependencies = {
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-path',
        },
        config = function()
            local cmp = require('cmp')
            cmp.setup {
                completion = { completeopt = 'menu,menuone,noinsert' },
                sources = {
                    -- set group index to 0 to skip loading LuaLS completions as lazydev recommends it
                    { name = 'lazydev', group_index = 0 },
                    { name = 'nvim_lsp' },
                    { name = 'path' },
                },
                mapping = cmp.mapping.preset.insert {
                    ['<C-n>'] = cmp.mapping.select_next_item(),
                    ['<C-p>'] = cmp.mapping.select_prev_item(),
                    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-f>'] = cmp.mapping.scroll_docs(4),
                    ['<CR>'] = cmp.mapping.confirm { select = true },
                    ['<C-x><C-o>'] = cmp.mapping.complete {},
                },
                snippet = {
                    expand = function(args)
                        vim.snippet.expand(args.body)
                    end,
                },
            }
        end,
    },

    -- LSP
    {
        'neovim/nvim-lspconfig',
        cmd = 'LspInfo',
        event = { 'BufReadPre', 'BufNewFile' },
        dependencies = {
            { 'williamboman/mason.nvim', cmd = { "Mason", "MasonInstall" }, config = true },
            { 'williamboman/mason-lspconfig.nvim' },
            { 'j-hui/fidget.nvim', opts = {} },
            { 'hrsh7th/cmp-nvim-lsp' },
        },
        config = function()
            vim.api.nvim_create_autocmd('LspAttach', {
                desc = 'Lsp Actions',
                group = vim.api.nvim_create_augroup('LSPSTUFF', { clear = true }),
                callback = function(event)
                    local client = vim.lsp.get_client_by_id(event.data.client_id)
                    if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
                        vim.keymap.set('n', '<leader>th', function()
                            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
                        end, { desc = '[T]oggle Inlay [H]ints', buffer = event.buf })
                    end
                end
            })

            local lspconfig = require('lspconfig')
            lspconfig.util.default_config.capabilities = vim.tbl_deep_extend(
                'force',
                vim.lsp.protocol.make_client_capabilities(),
                require('cmp_nvim_lsp').default_capabilities()
            )

            require('mason').setup {}
            require('mason-lspconfig').setup {
                ensure_installed = {},
                handlers = {
                    -- this first function is the "default handler"
                    -- it applies to every language server without a "custom handler"
                    function(server_name)
                        lspconfig[server_name].setup {}
                    end,
                },
                automatic_installation = false
            }
        end
    },
}
