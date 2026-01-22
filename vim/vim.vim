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

if has('gui_running') && !has('nvim')
    set lines=45 columns=160
    set guifont=SarasaMonoSC\ Nerd\ Font
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
if has('extra_search')
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
set guicursor=n-v-c-sm:block,i-ci-ve:ver25,r-cr:hor20,o:hor50,a:blinkon0
if has('nvim')
    set guicursor+=t:block
endif

" vim-terminal-help
let g:terminal_close = 1
let g:terminal_list = 0
let g:terminal_fixheight = 1

if !exists("g:neovide")
    " https://www.reddit.com/r/neovim/comments/zzs7eq/using_alacritty_but_no_transparency/
    augroup theme_transparency_patch
        autocmd!
        autocmd ColorScheme * highlight Normal      ctermbg=NONE guibg=NONE
        autocmd ColorScheme * highlight LineNr      ctermbg=NONE guibg=NONE
        autocmd ColorScheme * highlight Folded      ctermbg=NONE guibg=NONE
        autocmd ColorScheme * highlight NonText     ctermbg=NONE guibg=NONE
        autocmd ColorScheme * highlight SpecialKey  ctermbg=NONE guibg=NONE
        autocmd ColorScheme * highlight VertSplit   ctermbg=NONE guibg=NONE
        autocmd ColorScheme * highlight SignColumn  ctermbg=NONE guibg=NONE
        autocmd ColorScheme * highlight EndOfBuffer ctermbg=NONE guibg=NONE
        " this is specific to how I like my tabline to look like
        autocmd ColorScheme * highlight TablineFill ctermbg=NONE guibg=NONE
    augroup END
endif

augroup desert_patch
    autocmd!
    " only run these highlights when the colorscheme matches 'desert'
    " a deep, matte green that blends with the warm tones of desert
    autocmd ColorScheme desert highlight CursorLine cterm=NONE ctermbg=22 guibg=#2f4f2f
    autocmd ColorScheme desert highlight SpecialKey cterm=NONE guibg=NONE
    autocmd ColorScheme desert highlight NonText cterm=NONE guibg=NONE
    autocmd ColorScheme desert highlight MatchParen ctermbg=236 guibg=#303030
augroup END
colorscheme desert

IncScript keymaps.vim

function! g:RemoveTrailingWs()
    let saved = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(saved)
endfunction
command! RemoveTrailingWs call RemoveTrailingWs()
command! Cclear cgetexpr [] | cclose

if has('nvim')
    packloadall
endif
