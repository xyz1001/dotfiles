" nerdtree "
""""""""""""
map <Leader>n :NERDTreeToggle<cr>
let NERDTreeIgnore=[
    \'\.pyc$', '\.pyo$', '\.obj$',
    \'\.o$', '\.so$', '\.egg$',
    \'^\.git$', '^\.svn$', '^\.hg$' ]

let g:NERDTreeMapOpenSplit = 's'
let g:NERDTreeMapOpenVSplit = 'v'

autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
let NERDTreeRespectWildIgnore=1

"for nerdtree plugin open
let g:nerdtree_plugin_open_cmd = 'xdg-open'
