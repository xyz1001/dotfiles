"VIM通用配置，适用于所有VIM编辑器及插件

" 非兼容模式
set nocompatible

" 显示行号
set number

" 搜索设置
set ignorecase
set incsearch
set hlsearch

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

" 消息输出窗口
set cmdheight=2

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
set foldmethod=manual       " 设置缩进折叠

" 删除设置
set backspace=eol,start,indent

" 设置隐藏字符, 通过 set list 显示
set listchars=tab:▸\ ,eol:¬

" ++++++++++++++++++++++++++++++++++++++++
" +             快捷键配置               +
" ++++++++++++++++++++++++++++++++++++++++

"绑定大写的 HL 为行首和行尾的快捷键
noremap H ^
noremap L $

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

nnoremap <silent> <Backspace> :nohl<CR>
