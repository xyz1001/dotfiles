autocmd BufWritePre * undojoin | Neoformat
"autocmd BufWritePre *.py undojoin | Neoformat
"autocmd BufWritePre *.css,*.qss undojoin | Neoformat
let g:neoformat_cmake_cmakeformat = {
            \ 'exe': 'cmake-format',
            \ 'args': ['-c ~/.cmake-format.yaml'],
            \ }
