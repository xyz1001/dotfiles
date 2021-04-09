"nnoremap <C-i> :ClangFormat<CR>

autocmd BufWritePre *.cpp,*.c,*.h,*.hpp ClangFormat
