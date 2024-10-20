let s:scripthome = fnamemodify(resolve(expand('<sfile>:p')), ':h')
command! -nargs=1 IncScript exec 'so '. fnameescape(s:home."/<args>")
exec 'set rtp+='. fnameescape(s:scripthome)

if has("gui_running")
    set lines=45 columns=160
    set guifont=Sarasa\ Mono\ SC
    set guioptions-=T
endif

set nocompatible
syntax on
filetype plugin indent on
set backspace=indent,eol,start
set history=200
set ruler
set showcmd
set wildmenu
set display=lastline

set belloff=all
set autoread

let g:mapleader = " "
let g:maplocalleader = " "

" do not overwrite the unnamed register when pasting in visual mode
xnoremap <silent> p P

if has('clipboard')
    set clipboard=unnamedplus
endif

set nu
set rnu
set scrolloff=5

set nohidden

set tabstop=4
set shiftwidth=4
set expandtab

set ignorecase
set smartcase
set incsearch

set cursorline
set listchars=space:·,nbsp:⎵,tab:▸-
set list

if !has('nvim')
    if has('win32')
        set viminfofile=~\vimfiles\viminfo
    else
        set viminfofile=~/.vim/viminfo
    endif
endif

set isfname+=@-@

" https://vim-jp.org/vimdoc-en/indent.html#cinoptions-values
set cinoptions=l1N-sE-st0Lsg0

function g:RemoveTrailingWs()
    let saved = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(saved)
endfunction
command! RemoveTrailingWs call RemoveTrailingWs()

augroup VIMSTUFF
    autocmd!
    " restore cusor style on quit
    autocmd VimLeave * set guicursor= | call chansend(v:stderr, "\x1B[ q")
    " remember last edit position in files
    autocmd BufReadPost *
                \ let line = line("'\"")
                \ | if line >= 1 && line <= line("$") && &filetype !~# 'commit'
                \      && index(['xxd', 'gitrebase'], &filetype) == -1
                \ |   execute "normal! g`\""
                \ | endif
    " Quite a few people accidentally type "q:" instead of ":q" and get confused
    " by the command line window.  Give a hint about how to get out.
    autocmd CmdwinEnter *
                \ echohl Todo |
                \ echo gettext('You discovered the command-line window! You can close it with ":q".') |
                \ echohl None
augroup END

set ttimeout
if $TMUX != ''
    set ttimeoutlen=20
else
    set ttimeoutlen=50
endif

if exists(':packadd')
    silent! packadd matchit
endif
