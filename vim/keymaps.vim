let g:mapleader = " "
let g:maplocalleader = " "

if maparg('<C-L>', 'n') ==# ''
    nnoremap <silent> <C-L> :noh<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>
endif

" do NOT overwrite the unnamed register when pasting in visual mode.
xnoremap <silent> p P

" window
nnoremap <silent> <leader>= :resize +3<CR>
nnoremap <silent> <leader>- :resize -3<CR>
nnoremap <silent> <leader>, :vertical resize -3<CR>
nnoremap <silent> <leader>. :vertical resize +3<CR>
