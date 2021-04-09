" vim-cpplint "
"""""""""""""""

let g:cpplint_cmd = 'cpplint'
let g:cpplint_filter = '-whitespace/indent,-build/include'

command! Cpplint call Cpplint()
