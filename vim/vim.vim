let s:scripthome = fnamemodify(resolve(expand('<sfile>:p')), ':h')
command! -nargs=1 IncScript exec 'so '. fnameescape(s:scripthome."/<args>")
exec 'set rtp+='. fnameescape(s:scripthome)
exec 'set packpath+=' . fnameescape(s:scripthome)

if has("gui_running") && !has("nvim")
    set lines=45 columns=160
    set guifont=Sarasa\ Mono\ SC
    set guioptions-=T
endif

if exists("g:neovide")
    set guifont=SarasaMonoSC\ Nerd\ Font:h10
    let g:neovide_opacity = 0.9
    let g:neovide_normal_opacity = 0.9
    let g:neovide_animation_length = 0
    let g:neovide_cursor_trail_size = 0
end

" https://github.com/vim-airline/vim-airline/issues/2693
function! s:AirlineAfterTheme()
    hi StatusLine cterm=NONE gui=NONE
    hi StatusLineNC cterm=NONE gui=NONE
    hi StatusLineTerm cterm=NONE gui=NONE
    hi StatusLineTermNC cterm=NONE gui=NONE
endfunction
autocmd User AirlineAfterTheme call s:AirlineAfterTheme()

packadd vim-sensible
let g:airline#extensions#tabline#enabled = 1
packadd vim-airline
packadd vim-terminal-help

helptags ALL

augroup vim-stuff
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

if !has('nvim')
    let &t_SI = "\e[6 q"
    let &t_SR = "\e[3 q"
    let &t_EI = "\e[2 q"

    set <M-H>=H
    set <M-J>=J
    set <M-K>=K
    set <M-L>=L
endif

set belloff=all
set nohidden
set autoindent
set nu
set rnu
if has("extra_search")
    set hls
endif
set list
set isfname+=@-@
set cursorline
set ignorecase
set smartcase
set shiftwidth=4
set expandtab
set cinoptions=l1N-sE-st0Lsg0
set mouse=a
set guicursor+=a:blinkon0
set guicursor=n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20,a:blinkon0

colorscheme desert

IncScript keymaps.vim

function! g:RemoveTrailingWs()
    let saved = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(saved)
endfunction
command! RemoveTrailingWs call RemoveTrailingWs()
