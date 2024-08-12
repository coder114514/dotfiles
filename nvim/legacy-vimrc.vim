syntax on

filetype plugin indent on

" set number
" set relativenumber
" 
" set tabstop=4
" set shiftwidth=4
" set expandtab
" 
" set ignorecase
" set smartcase
" set incsearch

set ruler
set hidden
set cursorline
set visualbell
set autoread
set backspace=indent,eol,start
set listchars=space:·,nbsp:⎵,tab:▸-

autocmd VimLeave * set guicursor= | call chansend(v:stderr, "\x1b[ q") " restore cusor style on quit

" https://vim-jp.org/vimdoc-en/indent.html#cinoptions-values
set cinoptions=l1N-sE-st0Lsg0
let g:c_space_errors = 1
