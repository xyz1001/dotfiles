let g:fterm_disable_map=1
let g:fterm_autoquit = 1
let g:asyncrun_runner = get(g:, 'asyncrun_runner', {})
let g:asyncrun_runner.fterm = function('fterm#async_runner')

noremap <silent><leader>a :<c-u>FtermToggle<cr>
tnoremap <silent><leader>a <c-\><c-n>:<c-u>FtermToggle<cr>
tnoremap <c-a> <c-\><c-n>
