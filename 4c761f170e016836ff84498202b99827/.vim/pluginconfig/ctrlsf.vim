" ctrlsf "
""""""""""

let g:ctrlsf_backend = 'rg'

map      <C-E>  <NONE>
nmap     <C-E>f <Plug>CtrlSFPrompt
vmap     <C-E>f <Plug>CtrlSFVwordPath
vmap     <C-E>F <Plug>CtrlSFVwordExec
nmap     <C-E>n <Plug>CtrlSFCwordPath
nmap     <C-E>p <Plug>CtrlSFPwordPath
nnoremap <C-E>o :CtrlSFOpen<CR>
nnoremap <C-E>t :CtrlSFToggle<CR>
