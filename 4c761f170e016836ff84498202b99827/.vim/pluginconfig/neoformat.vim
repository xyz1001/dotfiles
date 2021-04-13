let g:auto_format = 1

command! -nargs=? Autoformat call ToggleAutoFormat()

function! ToggleAutoFormat()
    if g:auto_format
        let g:auto_format = 0
    else
        let g:auto_format = 1
    endif
endfunction

autocmd BufWritePre * if &ft == 'cpp' && g:auto_format |silent Neoformat|endif
autocmd BufWritePre * if &ft == 'python' && g:auto_format |silent Neoformat|endif
autocmd BufWritePre * if &ft == 'go' && g:auto_format |silent Neoformat|endif
autocmd BufWritePre * if &ft == 'c' && g:auto_format |silent Neoformat|endif

let g:neoformat_enabled_cpp=['clangformat']
let g:neoformat_enabled_python=['autopep8']
