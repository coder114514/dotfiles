set belloff=all
set nohidden
set autoindent
set rnu
if has("extra_search")
    set hls
endif
if maparg('<C-L>', 'n') ==# ''
    nnoremap <silent> <C-L> :noh<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>
endif
