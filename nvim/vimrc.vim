set termguicolors
let g:gruvbox_contrast_dark='hard'
let g:gruvbox_contrast_light='hard'
colorscheme gruvbox

syntax on

filetype plugin indent on

set tabstop=4
set shiftwidth=4
set expandtab

set ignorecase
set smartcase
set incsearch

set number
set ruler
set hidden
set cursorline
set visualbell
set autoread
set backspace=indent,eol,start
set listchars=space:·,nbsp:⎵,tab:▸-

" https://vim-jp.org/vimdoc-en/indent.html#cinoptions-values
set cinoptions=l1N-sE-st0Lsg0
let g:c_space_errors = 1

autocmd VimLeave * set guicursor= | call chansend(v:stderr, "\x1b[ q") # restore cusor style on quit
