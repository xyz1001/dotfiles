" ack.vim "
"""""""""""

" use rg as the search tool
if executable('rg')
  let g:ackprg = 'rg --vimgrep'
endif
