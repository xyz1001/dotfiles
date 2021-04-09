" vim-fswitch "
"""""""""""""""

au! BufEnter *.h let b:fswitchdst = 'cpp,cc,mm,c,m'
au! BufEnter *.hpp let b:fswitchdst = 'cpp,cc,mm,c,m'
au! BufEnter *.cc let b:fswitchdst = 'h,hpp'
au! BufEnter *.mm let b:fswitchdst = 'h' | let b:fswitchlocs = 'reg:/include/src/,reg:/include.*/src/,ifrel:|/include/|../src|'

nmap <silent> <Leader>s :FSHere<cr>
