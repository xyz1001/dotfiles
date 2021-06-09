" Enable alignment
let g:neoformat_basic_format_align = 1

" Enable tab to spaces conversion
let g:neoformat_basic_format_retab = 1

" Enable trimmming of trailing whitespace
let g:neoformat_basic_format_trim = 1

let g:format_on_save = 1

command! -nargs=? ToggleFormatOnSave call ToggleFormatOnSave()

function! ToggleFormatOnSave()
    if g:format_on_save
        echo "Format on save is off"
        let g:format_on_save = 0
    else
        echo "Format on save is on"
        let g:format_on_save = 1
    endif
endfunction

autocmd BufWritePre * if &ft == 'cpp' && g:format_on_save |silent Neoformat|endif
autocmd BufWritePre * if &ft == 'python' && g:format_on_save |silent Neoformat|endif
autocmd BufWritePre * if &ft == 'go' && g:format_on_save |silent Neoformat|endif
autocmd BufWritePre * if &ft == 'c' && g:format_on_save |silent Neoformat|endif
autocmd BufWritePre * if &ft == 'objc' && g:format_on_save |silent Neoformat|endif
autocmd BufWritePre * if &ft == 'glsl' && g:format_on_save |silent Neoformat|endif

let g:neoformat_enabled_cpp=['clangformat']
let g:neoformat_enabled_objc=['clangformat']
let g:neoformat_enabled_glsl=['clangformat']
let g:neoformat_enabled_python=['autopep8']
let g:neoformat_enabled_go=['gofmt']
