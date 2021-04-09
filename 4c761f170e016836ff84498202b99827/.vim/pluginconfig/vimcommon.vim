" ++++++++++++++++++++++++++++++++++++++++
" +             基础选项配置             +
" ++++++++++++++++++++++++++++++++++++++++

" 非兼容模式
set nocompatible

" 显示行号
set number
set relativenumber

" 搜索设置
set ignorecase
set incsearch
set hlsearch

" 开启鼠标
set mouse=a

" 切换缓冲区文件可以不保存当前文件
set hidden

" 默认开启语法高亮
syntax on

" tabs
set expandtab
set softtabstop=4
set shiftwidth=4
set tabstop=4

" 缩进设置，设置基于文件的类型的缩进
set autoindent
set cino=(0,W4
filetype plugin indent on

" 改变超过 80 个字符之后的区域，这样就可以起到提示作用
set colorcolumn=81
set fo+=mB " 支持中文
set wrap

" 自动载入外部修改
set autoread

" 关闭延时
set ttimeoutlen=0

" 编码设置
set encoding=utf-8
set fileencodings=utf-8,ucs-bom,GB2312,big5

" 高亮当前行
set cursorline

" 智能补全命令行
set wildmenu
set wildmode=full

" 不显示状态，airline已有
set noshowmode

" 代码折叠
set foldenable              " 开始折叠
set foldmethod=indent       " 设置缩进折叠
set foldcolumn=0            " 设置折叠区域的宽度
setlocal foldlevel=1        " 最大只折叠一层
set foldlevelstart=99       " 打开文件默认不折叠代码

" 删除设置
set backspace=eol,start,indent

" 设置隐藏字符, 通过 set list 显示
set listchars=tab:▸\ ,eol:¬

if !isdirectory($HOME."/.undo_history")
    call mkdir($HOME."/.undo_history", "", 0700)
endif
" undo 历史保存路径
set undodir=~/.undo_history/
" 开启保存 undo 历史功能
set undofile

" ++++++++++++++++++++++++++++++++++++++++
" +             快捷键配置               +
" ++++++++++++++++++++++++++++++++++++++++

" 修改leader键
let mapleader = ';'
let maplocalleader = ','

"绑定大写的 HL 为行首和行尾的快捷键
noremap H ^
noremap L $

" 交换 ' 和 ` 的功能
nnoremap ' `
nnoremap ` '
noremap + ;
noremap - ,


" 使用 %% 扩展当前文件的路径
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'

" 使得 & 命令能够重复上一次的命令，包括 flag
nnoremap & :&&<CR>
xnoremap & :&&<CR>

" 命令行模式 Ctrl-j 下一条命令，Ctrl-k 上一条命令
cnoremap <C-j> <Down>
cnoremap <C-k> <Up>
cnoremap <C-h> <Left>
cnoremap <C-l> <Right>
cnoremap <C-a> <Home>
cnoremap <C-e> <End>

" 系统剪贴板复制与粘贴
nnoremap <C-p> "+gp
vnoremap <C-p> "+gp
vnoremap <C-y> "+y

" 复制
nnoremap <Leader>y yiw

" j/k在没有计数的时候按虚拟行移动，有计数的时候按实际行移动
nnoremap <expr> j v:count ? 'j' : 'gj'
nnoremap <expr> k v:count ? 'k' : 'gk'

nnoremap <silent> <Space> @=(foldlevel('.')?'za':"\<Space>")<CR>
nnoremap <silent> <Backspace> :nohl<CR>

" 使用超级用户权限编辑这个文件
cmap w!! w !sudo tee >/dev/null %

" 调整宽度
cmap v= vertical resize +5<cr>
cmap v- vertical resize -5<cr>
cmap s= resize +5<cr>
cmap s- resize -5<cr>

if has('win32')
    set shell=powershell
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                自动命令配置                                "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" 将光标设为上次退出时的位置
autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

autocmd BufNewFile *.cpp,*.c,*.h,*.hpp 0r ~/.license
autocmd BufNewFile,BufFilePre,BufRead *.qss set filetype=css
autocmd BufNewFile,BufFilePre,BufRead *.ts set filetype=xml
autocmd BufNewFile,BufFilePre,BufRead *.ui set filetype=xml
autocmd BufNewFile,BufFilePre,BufRead *.qrc set filetype=xml
autocmd BufNewFile,BufFilePre,BufRead *.mm set filetype=objc
autocmd BufNewFile,BufFilePre,BufRead *.m set filetype=objc
" vim 类型文件设置折叠方式为 marker
autocmd FileType vim set foldmethod=marker
