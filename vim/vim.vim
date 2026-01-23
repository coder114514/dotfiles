let s:is_win = has('win32') || has('win64')
let s:scripthome = fnamemodify(resolve(expand('<sfile>:p')), ':h')
if s:is_win
    command! -nargs=1 IncScript exec 'so '. fnameescape(s:scripthome."\\<args>")
else
    command! -nargs=1 IncScript exec 'so '. fnameescape(s:scripthome."/<args>")
endif
exec 'set rtp+='. fnameescape(s:scripthome)
exec 'set packpath+=' . fnameescape(s:scripthome)

function! g:ConfigHome()
    return s:scripthome
endfunction
command! CdConfig execute "cd " . ConfigHome()

augroup vim_stuff
    autocmd!
    " Remember last edit position in files.
    autocmd BufReadPost *
                \ let line = line("'\"") |
                \ if 1 <= line && line <= line("$")
                \    && &filetype !~# 'commit'
                \    && index(['xxd', 'gitrebase'], &filetype) == -1 |
                \   execute "normal! g`\"" |
                \ endif
augroup END

set belloff=all
set nohidden
set autoindent
set nu rnu
if has('extra_search')
    set hls
endif
set cursorline
set ignorecase
set smartcase
set shiftwidth=4
set expandtab
set cinoptions=l1N-sE-st0Lsg0
set mouse=a
set guicursor=a:block-blinkon0
set list
set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+

set completeopt=menu,menuone,fuzzy,noselect
set shortmess+=c

set <M-H>=H
set <M-J>=J
set <M-K>=K
set <M-L>=L

noremap  <M-H> <C-w>h
noremap  <M-L> <C-w>l
noremap  <M-J> <C-w>j
noremap  <M-K> <C-w>k
inoremap <M-H> <Esc><C-w>h
inoremap <M-L> <Esc><C-w>l
inoremap <M-J> <Esc><C-w>j
inoremap <M-K> <Esc><C-w>k
tnoremap <M-H> <C-\><C-n><C-w>h
tnoremap <M-L> <C-\><C-n><C-w>l
tnoremap <M-J> <C-\><C-n><C-w>j
tnoremap <M-K> <C-\><C-n><C-w>k
tnoremap <M-N> <C-\><C-n><C-w>p
tnoremap <M-q> <C-\><C-n>

function! s:OpenTerm(vertical, use_buffer_cwd)
    let l:original_cwd = getcwd()
    let l:buf_dir = expand('%:p:h')
    if a:use_buffer_cwd
        if isdirectory(l:buf_dir)
            execute 'cd ' . fnameescape(l:buf_dir)
        else
            echoerr "Current buffer is not a file or directory does not exist."
            return
        endif
    endif
    if a:vertical
        execute 'bot vert term'
    else
        execute 'bot term'
    endif
    if a:use_buffer_cwd
        execute 'cd ' . fnameescape(l:original_cwd)
    endif
    startinsert
endfunction

command! Term   call s:OpenTerm(0, 0)
command! Termv  call s:OpenTerm(1, 0)
command! Termb  call s:OpenTerm(0, 1)
command! Termbv call s:OpenTerm(1, 1)

" https://www.reddit.com/r/neovim/comments/zzs7eq/using_alacritty_but_no_transparency/
function! s:FixTransparency()
    highlight Normal      ctermbg=NONE guibg=NONE
    highlight LineNr      ctermbg=NONE guibg=NONE
    highlight Folded      ctermbg=NONE guibg=NONE
    highlight NonText     ctermbg=NONE guibg=NONE
    highlight SpecialKey  ctermbg=NONE guibg=NONE
    highlight VertSplit   ctermbg=NONE guibg=NONE
    highlight SignColumn  ctermbg=NONE guibg=NONE
    highlight EndOfBuffer ctermbg=NONE guibg=NONE
    highlight TablineFill ctermbg=NONE guibg=NONE
endfunction
call s:FixTransparency()
augroup theme_transparency_patch
    autocmd!
    autocmd ColorScheme * call s:FixTransparency()
augroup END

let g:mapleader = " "
let g:maplocalleader = " "

" window
nnoremap <silent> <leader>= :resize +3<CR>
nnoremap <silent> <leader>- :resize -3<CR>
nnoremap <silent> <leader>, :vertical resize -3<CR>
nnoremap <silent> <leader>. :vertical resize +3<CR>

nnoremap <silent> <leader>u :UndotreeToggle<CR>

nnoremap <silent> [q :cprevious<CR>
nnoremap <silent> ]q :cnext<CR>

function! g:RemoveTrailingWs()
    let saved = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(saved)
endfunction
command! RemoveTrailingWs call g:RemoveTrailingWs()
command! Cclear cgetexpr [] | cclose
