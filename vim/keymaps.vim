let g:mapleader = " "
let g:maplocalleader = " "

" do NOT overwrite the unnamed register when pasting in visual mode.
xnoremap <silent> p P

" fast save
nnoremap <C-S> :w<cr>
inoremap <C-S> <ESC>:w<cr>

"----------------------------------------------------------------------
" Movement Enhancement
"----------------------------------------------------------------------
inoremap <silent> <C-h> <left>
inoremap <silent> <C-l> <right>
inoremap <silent> <C-j> <down>
inoremap <silent> <C-k> <up>
noremap <M-h> b
noremap <M-l> w
noremap <M-j> gj
noremap <M-k> gk
inoremap <M-h> <c-left>
inoremap <M-l> <c-right>
inoremap <M-j> <c-\><c-o>gj
inoremap <M-k> <c-\><c-o>gk
inoremap <M-y> <c-\><c-o>d$
cnoremap <M-h> <c-left>
cnoremap <M-l> <c-right>
cnoremap <M-b> <c-left>
cnoremap <M-f> <c-right>

"----------------------------------------------------------------------
" fast window switching: ALT+SHIFT+HJKL
"----------------------------------------------------------------------
noremap <m-H> <c-w>h
noremap <m-L> <c-w>l
noremap <m-J> <c-w>j
noremap <m-K> <c-w>k
inoremap <m-H> <esc><c-w>h
inoremap <m-L> <esc><c-w>l
inoremap <m-J> <esc><c-w>j
inoremap <m-K> <esc><c-w>k

if has('terminal') && exists(':terminal') == 2 && has('patch-8.1.1')
    set termwinkey=<c-_>
    tnoremap <m-H> <c-_>h
    tnoremap <m-L> <c-_>l
    tnoremap <m-J> <c-_>j
    tnoremap <m-K> <c-_>k
    tnoremap <m-q> <c-\><c-n>
    tnoremap <m-1> <c-_>1gt
    tnoremap <m-2> <c-_>2gt
    tnoremap <m-3> <c-_>3gt
    tnoremap <m-4> <c-_>4gt
    tnoremap <m-5> <c-_>5gt
    tnoremap <m-6> <c-_>6gt
    tnoremap <m-7> <c-_>7gt
    tnoremap <m-8> <c-_>8gt
    tnoremap <m-9> <c-_>9gt
    tnoremap <m-0> <c-_>10gt
elseif has('nvim')
    tnoremap <m-H> <c-\><c-n><c-w>h
    tnoremap <m-L> <c-\><c-n><c-w>l
    tnoremap <m-J> <c-\><c-n><c-w>j
    tnoremap <m-K> <c-\><c-n><c-w>k
    tnoremap <m-q> <c-\><c-n>
    tnoremap <m-1> <c-\><c-n>1gt
    tnoremap <m-2> <c-\><c-n>2gt
    tnoremap <m-3> <c-\><c-n>3gt
    tnoremap <m-4> <c-\><c-n>4gt
    tnoremap <m-5> <c-\><c-n>5gt
    tnoremap <m-6> <c-\><c-n>6gt
    tnoremap <m-7> <c-\><c-n>7gt
    tnoremap <m-8> <c-\><c-n>8gt
    tnoremap <m-9> <c-\><c-n>9gt
    tnoremap <m-0> <c-\><c-n>10gt
endif
