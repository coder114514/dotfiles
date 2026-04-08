--- vim: set sw=2 et :
-----------------------------------------------------------------------------
---- Configurable Variables before loading this script:
---    vim.g.have_nerd_font
----   vim.g.lazyroot
---    vim.g.lsps
-----------------------------------------------------------------------------

local scriptpath = debug.getinfo(1, 'S').source:sub(2)
local scripthome = vim.fn.fnamemodify(scriptpath, ':h')
local is_windows = package.config:sub(1, 1) == '\\'
if is_windows then
  scripthome = scripthome:gsub('/', '\\')
else
  scripthome = scripthome:gsub('\\', '/')
end
local path_sep = is_windows and '\\' or '/'

package.path = package.path .. ';' .. scripthome .. path_sep .. '?.lua'

vim.cmd.source(scripthome .. path_sep .. 'vim.vim')

vim.opt.undofile = true -- for undo tree

vim.api.nvim_create_user_command('Diags', function()
  vim.diagnostic.setqflist()
end, { desc = 'Add all diagnostics to the quickfix list.' })

vim.cmd.packloadall()

vim.keymap.set('n', '<leader>th', function()
  print('Inlay Hints Not Loaded')
end, { desc = 'LSP: [T]oggle Inlay [H]ints' })

vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'Lsp Actions',
  group = vim.api.nvim_create_augroup('lsp_stuff', { clear = true }),
  callback = function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
      vim.keymap.set('n', '<leader>th', function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
      end, { desc = '[T]oggle Inlay [H]ints', buffer = event.buf })
    end
  end,
})

if vim.g.lsps then
  for _, lsp in pairs(vim.g.lsps) do
    local name, config = lsp[1], lsp[2]
    vim.lsp.enable(name)
    if config then
      vim.lsp.config(name, config)
    end
  end
end

local lazyroot = vim.g.lazyroot or vim.fn.stdpath 'data' .. path_sep .. 'lazy'
local lazypath = lazyroot .. path_sep .. 'lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system({ 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { 'Failed to clone lazy.nvim:\n', 'ErrorMsg' },
      { out, 'WarningMsg' },
      { '\nPress any key to exit...' },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.runtimepath:prepend(lazypath)

local opts = {
  root = lazyroot,
  performance = {
    reset_packpath = false,
    rtp = {
      reset = false,
    },
  },
  ui = {
    icons = vim.g.have_nerd_font and {} or { cmd = '', config = '', event = '', ft = '', init = '', keys = '', plugin = '', runtime = '', require = '', source = '', start = '', task = '', lazy = '' },
  },
  rocks = {
    enabled = false,
  },
}

local specs = {
  install = { colorscheme = { "default" } },

  {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    build = ':TSUpdate',
    branch = 'main',
    config = function()
      -- ensure basic parsers are installed
      local parsers = { 'bash', 'zsh', 'c', 'cpp', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc' }
      require('nvim-treesitter').install(parsers)

      local function treesitter_try_attach(buf, lang)
        -- check if parser exists and load it
        if not vim.treesitter.language.add(lang) then return end
        -- enable syntax highlighting and other treesitter features
        vim.treesitter.start(buf, lang)
        -- enable treesitter-based folds, see `:help folds`
        vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
        vim.wo.foldmethod = 'expr'
        -- enable treesitter-based identation if there is
        local has_indent = vim.treesitter.query.get(lang, "indents")
        if has_indent then
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
        -- start with no folds closed
        vim.wo.foldlevel = 99
      end

      local available_parsers = require('nvim-treesitter').get_available()
      vim.api.nvim_create_autocmd('FileType', {
        callback = function(args)
          local buf, filetype = args.buf, args.match

          local lang = vim.treesitter.language.get_lang(filetype)
          if not lang then return end

          local installed_parsers = require('nvim-treesitter').get_installed 'parsers'

          if vim.tbl_contains(installed_parsers, lang) then
            -- enable the parser if it is installed
            treesitter_try_attach(buf, lang)
          elseif vim.tbl_contains(available_parsers, lang) then
            -- if a parser is available in `nvim-treesitter` auto install it, and enable it after the installation is done
            require('nvim-treesitter').install(lang):await(function() treesitter_try_attach(buf, lang) end)
          else
            -- try to enable treesitter features in case the parser exists but is not available from `nvim-treesitter`
            treesitter_try_attach(buf, lang)
          end
        end,
      })
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = 'main',
    config = function()
      require("nvim-treesitter-textobjects").setup {
        select = {
          -- Automatically jump forward to textobj, similar to targets.vim
          lookahead = true,
        },
        move = {
          -- whether to set jumps in the jumplist
          set_jumps = true,
        },
      }

      local tobj_keymaps = {
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
        ["aa"] = "@parameter.outer",
        ["ia"] = "@parameter.inner",
        ["ab"] = "@block.outer",
        ["ib"] = "@block.inner",
      }
      for keys, tobj in pairs(tobj_keymaps) do
        vim.keymap.set({ "x", "o" }, keys, function()
          require "nvim-treesitter-textobjs.select".select_textobject(tobj, "textobjects")
        end)
      end

      vim.keymap.set("n", "<leader>a", function()
        require("nvim-treesitter-textobjects.swap").swap_next "@parameter.inner"
      end)
      vim.keymap.set("n", "<leader>A", function()
        require("nvim-treesitter-textobjects.swap").swap_previous "@parameter.outer"
      end)

      local move_keymaps = {
        goto_next_start = {
          ["]m"] = "@function.outer",
          ["]]"] = "@class.outer",
        },
        goto_next_end = {
          ["]M"] = "@function.outer",
          ["]["] = "@class.outer",
        },
        goto_previous_start = {
          ["[m"] = "@function.outer",
          ["[["] = "@class.outer",
        },
        goto_previous_end = {
          ["[M"] = "@function.outer",
          ["[]"] = "@class.outer",
        },
      }
      for move, keymaps in pairs(move_keymaps) do
        for keys, tobj in pairs(keymaps) do
          vim.keymap.set({ "n", "x", "o" }, keys, function()
            require("nvim-treesitter-textobjects.move")[move](tobj, "textobjects")
          end)
        end
      end
    end
  },

  {
    'nvim-telescope/telescope.nvim',
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

      vim.keymap.set('n', '<leader>sn', function()
        builtin.find_files { cwd = vim.fn.stdpath 'config'  }
      end, { desc = '[S]earch [N]eovim files' })

      vim.keymap.set('n', '<leader>sc', function()
        builtin.find_files { cwd = scripthome, file_ignore_patterns = { '^pack/', '^pack\\'  } }
      end, { desc = '[S]earch [C]onfig files' })

      -- Replace some default LSP shortcuts with those of telescope and add better descriptions
      vim.keymap.set('n',          'grn', vim.lsp.buf.rename,                    { desc = 'LSP: Re[n]ame' })
      vim.keymap.set({ 'n', 'x' }, 'gra', vim.lsp.buf.code_action,               { desc = 'LSP: Code [A]ction' })
      vim.keymap.set('n',          'grr', builtin.lsp_references,                { desc = 'LSP: Goto [R]eferences' })
      vim.keymap.set('n',          'gri', builtin.lsp_implementations,           { desc = 'LSP: Goto [I]mplementation' })
      vim.keymap.set('n',          'grd', builtin.lsp_definitions,               { desc = 'LSP: Goto [D]efinition' })
      vim.keymap.set('n',          'grD', vim.lsp.buf.declaration,               { desc = 'LSP: Goto [D]eclaration' })
      vim.keymap.set('n',          'grt', builtin.lsp_type_definitions,          { desc = 'LSP: [T]ype Definition' })
      vim.keymap.set('n',          'gO',  builtin.lsp_document_symbols,          { desc = 'LSP: [O]pen Document Symbols' })
      vim.keymap.set('n',          'gW',  builtin.lsp_dynamic_workspace_symbols, { desc = 'LSP: Open [W]orkspace Symbols' })
    end,
  },

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
        { path = 'xmake-luals-addon/library', files = { 'xmake.lua' } },
      },
    },
  },

  {
    'neovim/nvim-lspconfig',
    cmd = 'LspInfo',
    event = { 'BufReadPre', 'BufNewFile' },
  },
}

require('lazy').setup(specs, opts)
