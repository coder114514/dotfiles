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
set undofile
if has('win32')
    set undodir=~\vimfiles\undodir
else
    set undodir=~/.vim/undodir
endif

if has('win32')
    set viminfofile=~\vimfiles\viminfo
else
    set viminfofile=~/.vim/viminfo
endif

set isfname+=@-@

set gp=git\ grep\ -n

" https://vim-jp.org/vimdoc-en/indent.html#cinoptions-values
set cinoptions=l1N-sE-st0Lsg0

set guifont=Sarasa\ Mono\ SC
set guioptions-=T

let g:mapleader = " "
let g:maplocalleader = "\\"

nnoremap <leader>u :UndotreeToggle<cr>

packadd! matchit

function g:RemoveTrailingWs()
    let view = winsaveview()
    let [_, line, col, _, _] = getcurpos()
    execute printf('%d substitute/\%%%dc\s\+$//e', line, col)
    execute printf('vglobal/\%%%dl/substitute/\s\+$//e', line)
    call winrestview(view)
endfunction

command! RemoveTrailingWs call RemoveTrailingWs()

function g:StartLsp()
    packadd vim-lsp
    packadd vim-lsp-settings

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

    call lsp#enable()
endfunction

:command! Lsp call StartLsp()
