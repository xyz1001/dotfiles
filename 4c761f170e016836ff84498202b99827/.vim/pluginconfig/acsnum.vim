function! AscendingNumber()
    let i=1 | g/\d. /s//\=i.'. '/ | let i=i+1
endfunction
nnoremap <silent> <Leader>a :call AscendingNumber()<CR>

function! VAscendingNumber()
    let i=1 | '<,'> g/\d. /s//\=i.'. '/ | let i=i+1
endfunction
vnoremap <silent> <Leader>a :call VAscendingNumber()<CR>
