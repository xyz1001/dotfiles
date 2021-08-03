" nerdtree "
""""""""""""
map <Leader>n :NERDTreeToggle<cr>

let NERDTreeRespectWildIgnore=1
let NERDTreeIgnore=[ '\.pyc$', '\.pyo$', '\.obj$', '\.o$', '\.so$', '\.egg$', '^\.git$', '^\.svn$', '^\.hg$', '^\.vs$', ]

let g:NERDTreeMapOpenSplit = 's'
let g:NERDTreeMapOpenVSplit = 'v'

autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

"for nerdtree plugin open
if executable('xdg-open')
    let g:nerdtree_plugin_open_cmd = 'xdg-open'
elseif executable('open')
    let g:nerdtree_plugin_open_cmd = 'open'
elseif executable('start')
    let g:nerdtree_plugin_open_cmd = 'start'
elseif executable('termux-open')
    let g:nerdtree_plugin_open_cmd = 'termux-open'
endif
