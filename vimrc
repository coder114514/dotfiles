syntax on

filetype plugin indent on

colorscheme desert

set nu

set tabstop=4
set shiftwidth=4
set expandtab

set ignorecase
set smartcase
set incsearch

set ruler
set cursorline
set belloff=all
set autoread
set listchars=space:·,nbsp:⎵,tab:▸-

set noswapfile
if has('win32')
    set undodir=~\vimfiles\undodir
else
    set undodir=~/.vim/undodir
endif
set undofile

set isfname+=@-@

set gp=git\ grep\ -n

" https://vim-jp.org/vimdoc-en/indent.html#cinoptions-values
set cinoptions=l1N-sE-st0Lsg0

set guifont=Sarasa\ Mono\ SC
set guioptions-=T

let g:mapleader = " "
let g:maplocalleader = "\\"

" gv: reuse last selection
vnoremap J :move '>+1<CR>gv=gv"
vnoremap K :move '<-2<CR>gv=gv"

" mz,J,`z
nnoremap J mzJ`z

vnoremap <leader>d "_d
nnoremap <leader>d "_d

nnoremap <leader>y "+y
vnoremap <leader>y "+y
nnoremap <leader>Y "+Y
nnoremap <leader>P "+P
nnoremap <leader>p "+p

packadd! matchit

nnoremap <leader>u :UndotreeToggle<cr>

function g:StartLsp()
    function! OnLspBufferEnabled() abort
        setlocal omnifunc=lsp#complete
        setlocal signcolumn=yes
        nmap <buffer> gi <plug>(lsp-definition)
        nmap <buffer> gd <plug>(lsp-declaration)
        nmap <buffer> gr <plug>(lsp-references)
        nmap <buffer> gl <plug>(lsp-document-diagnostics)
        nmap <buffer> go <plug>(lsp-type-definition)
        nmap <buffer> gs <plug>(lsp-signature-help)
        nmap <buffer> <F2> <plug>(lsp-rename)
        nmap <buffer> <F3> <plug>(lsp-hover)
    endfunction

    augroup lsp_install
        au!
        autocmd User lsp_buffer_enabled call OnLspBufferEnabled()
    augroup END
endfunction

call StartLsp()
