command! -nargs=? Cmake cclose|copen|wa|AsyncRun -cwd=<root>/build cmake ../<args>
command! -nargs=? Qmake cclose|copen|wa|AsyncRun -cwd=<root>/build qmake ../<args>
command! -nargs=? Make cclose|copen|wa|AsyncRun -cwd=<root>/build make <args>
command! -nargs=? Gitpush cclose|copen|AsyncRun git push <args>
autocmd FileType cpp nnoremap <Leader>b :Make<cr>
nnoremap <Leader>gp :Gitpush<CR>
