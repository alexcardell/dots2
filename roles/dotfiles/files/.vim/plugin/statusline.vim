scriptencoding utf-8

function! GitBranch()
  return system("git rev-parse --abbrev-ref HEAD 2>/dev/null | tr -d '\n'")
endfunction

function! DisplayGitBranch()
  let l:branchname = GitBranch()
  return strlen(l:branchname) > 0 ? ' '.l:branchname.' ' : ' '
endfunction

highlight ModeMsg ctermfg = 0

" 1 red 2 green 3 yellow 4 blue 5 magenta 6 aqua
" 18 dark grey
highlight StatusLine ctermfg=18 ctermbg=grey
highlight User2 ctermfg=grey ctermbg=18

au InsertEnter * highlight StatusLine ctermfg=18 ctermbg=green |
      \ highlight User2 ctermfg=green ctermbg=18
au InsertLeave * highlight StatusLine ctermfg=18 ctermbg=grey |
      \ highlight User2 ctermfg=grey ctermbg=18

" clear
set statusline=
" red bg
set statusline+=%#StatusLine#
" branch symbol
set statusline+=\ 
" get git branch
set statusline+=%{DisplayGitBranch()}
" red fg powerline symbol TODO: put unicode for this symbol in comment
set statusline+=%#User2#
" text highlight
set statusline+=%#CursorColumn#
" file
set statusline+=\ %f
" modified
set statusline+=\ %m
" start from right
set statusline+=%=
" faint text
set statusline+=%#LineNr#
" filetype
set statusline+=\ %y
" encoding
set statusline+=\ %{&fileencoding?&fileencoding:&encoding}[%{&fileformat}\]
" percent through file
set statusline+=\ %p%%
" line:col
set statusline+=\ %l:%c

" Handy symbols
" powerline left arrow  = 
" powerline right arrow = 
