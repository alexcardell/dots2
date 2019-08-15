nnoremap <leader>fa :Files<CR>

nnoremap <localleader>/ :Rg<Space>

nnoremap <leader>fb :Buffers<CR>

nnoremap <leader>fl :Lines<CR>

nnoremap <leader>f/ :BLines<CR>

nnoremap <leader>fh :Helptags<CR>

nnoremap <leader>fs :Snippets<CR>

let g:fzf_action = {
      \ 'ctrl-t': 'tab split',
      \ 'ctrl-s': 'split',
      \ 'ctrl-v': 'vsplit',
      \ }
