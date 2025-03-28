let s:scripthome = fnamemodify(resolve(expand('<sfile>:p')), ':h')
command! -nargs=1 IncScript exec 'so '. fnameescape(s:scripthome."/<args>")
exec 'set rtp+='. fnameescape(s:scripthome)

if has("gui_running") && !has("nvim")
    set lines=45 columns=160
    set guifont=Sarasa\ Mono\ SC
    set guioptions-=T
endif

if exists("g:neovide")
    set guifont=SarasaMonoSC\ Nerd\ Font:h10
    let g:neovide_transparency = 0.9
    let g:neovide_normal_opacity = 0.9
    let g:neovide_animation_length = 0
    let g:neovide_cursor_trail_size = 0
end

" many settings are adapted from tpope's vim-sensible and vim's defaults.vim

if &compatible
    set nocompatible
endif

set backspace=indent,eol,start
set complete-=i
set smarttab
set nrformats-=octal

set ttimeout
if $TMUX != ''
    set ttimeoutlen=20
else
    set ttimeoutlen=50
endif

" vim search
if has('reltime')
    set incsearch
endif
" Use CTRL-L to clear the highlighting of 'hlsearch' and call :diffupdate.
if maparg('<C-L>', 'n') ==# ''
    nnoremap <silent> <C-L> :nohls<C-R>=has('diff')?'<Bar>diffupdate':''<CR><Bar>normal! <C-L><CR>
endif

set laststatus=2
set ruler
set wildmenu

set scrolloff=1
set sidescroll=1
set sidescrolloff=2

set display+=lastline
if has('patch-7.4.2109')
    set display+=truncate
endif

set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+

" Delete comment character when joining commented lines.
if v:version > 703 || v:version == 703 && has("patch541")
    set formatoptions+=j
endif

" Replace the check for a tags file in the parent directory of the current
" file with a check in every ancestor directory.
if has('path_extra') && (',' . &g:tags . ',') =~# ',\./tags,'
    setglobal tags-=./tags tags-=./tags; tags^=./tags;
endif

set autoread
set history=1000
set tabpagemax=50

" Persist g:UPPERCASE variables, used by some plugins, in .viminfo.
" In nvim 'viminfo' is deprecated, use 'shada' instead.
" By default 'shada' already contains !
if !has('nvim') && !empty(&viminfo)
    set viminfo^=!
endif
" Saving options in session and view files causes more problems than it solves, so disable it.
set sessionoptions-=options
set viewoptions-=options

" Allow color schemes to do bright colors without forcing bold.
if !has('nvim')
    if &t_Co == 8 && $TERM !~# '^Eterm'
        set t_Co=16
    endif
endif

" If the running Vim lacks support for the Fish shell, use Bash instead.
if &shell =~# 'fish$' && (v:version < 704 || v:version == 704 && !has('patch276'))
    set shell=/usr/bin/env\ bash
endif

" Disable a legacy behavior that can break plugin maps.
if has('langmap') && exists('+langremap') && &langremap
    set nolangremap
endif

if !(exists('g:did_load_filetypes') && exists('g:did_load_ftplugin') && exists('g:did_indent_on'))
    filetype plugin indent on
endif
if has('syntax') && !exists('g:syntax_on')
    syntax enable
endif

if empty(mapcheck('<C-U>', 'i'))
    inoremap <C-U> <C-G>u<C-U>
endif
if empty(mapcheck('<C-W>', 'i'))
    inoremap <C-W> <C-G>u<C-W>
endif

" From `:help :DiffOrig`.
if exists(":DiffOrig") != 2
    command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_
                \ | diffthis | wincmd p | diffthis
endif

" Correctly highlight $() and other modern affordances in filetype=sh.
if !exists('g:is_posix') && !exists('g:is_bash') && !exists('g:is_kornshell') && !exists('g:is_dash')
    let g:is_posix = 1
endif

" Load matchit.vim, but only if the user hasn't installed a newer version.
if !exists('g:loaded_matchit') && findfile('plugin/matchit.vim', &rtp) ==# ''
    runtime! macros/matchit.vim
endif

" Enable the :Man command shipped inside Vim's man filetype plugin.
if exists(':Man') != 2 && !exists('g:loaded_man') && &filetype !=? 'man' && !has('nvim')
    runtime ftplugin/man.vim
endif

" Above settings are adapted from tpope's vim-sensible


set belloff=all
set showcmd
set list
set nohidden
set isfname+=@-@
set cursorline

set hls
set ignorecase
set smartcase

set nu
set rnu

set shiftwidth=4
set expandtab

set cinoptions=l1N-sE-st0Lsg0

set mouse=a


IncScript keymaps.vim

function! g:RemoveTrailingWs()
    let saved = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(saved)
endfunction
command! RemoveTrailingWs call RemoveTrailingWs()


augroup VIMSTUFF
    autocmd!
    " Restore cusor style on quit.
    autocmd VimLeave *
                \ set guicursor= |
                \ call chansend(v:stderr, "\x1B[ q")
    " Remember last edit position in files.
    autocmd BufReadPost *
                \ let line = line("'\"") |
                \ if 1 <= line && line <= line("$")
                \    && &filetype !~# 'commit'
                \    && index(['xxd', 'gitrebase'], &filetype) == -1 |
                \   execute "normal! g`\"" |
                \ endif
    " Quite a few people accidentally type "q:" instead of ":q" and get confused
    " by the command line window.  Give a hint about how to get out.
    autocmd CmdwinEnter *
                \ echohl Todo |
                \ echo gettext('You discovered the command-line window! You can close it with ":q".') |
                \ echohl None
augroup END
