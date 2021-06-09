" nerdtree "
""""""""""""
map <Leader>n :NERDTreeToggle<cr>

let NERDTreeRespectWildIgnore=1
let NERDTreeIgnore=[ '\.pyc$', '\.pyo$', '\.obj$', '\.o$', '\.so$', '\.egg$', '^\.git$', '^\.svn$', '^\.hg$', '^\.vs$', ]

let g:NERDTreeMapOpenSplit = 's'
let g:NERDTreeMapOpenVSplit = 'v'

autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

"for nerdtree plugin open
if has('x11')
    let g:nerdtree_plugin_open_cmd = 'xdg-open'
elseif has('mac')
    let g:nerdtree_plugin_open_cmd = 'open'
elseif has('win32')
    let g:nerdtree_plugin_open_cmd = 'start'
endif
