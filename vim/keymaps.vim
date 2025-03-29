let g:mapleader = " "
let g:maplocalleader = " "

" do NOT overwrite the unnamed register when pasting in visual mode.
xnoremap <silent> p P

" window
nnoremap <silent> <leader>= :resize +3<CR>
nnoremap <silent> <leader>- :resize -3<CR>
nnoremap <silent> <leader>, :vertical resize -3<CR>
nnoremap <silent> <leader>. :vertical resize +3<CR>
