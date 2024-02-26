"VIM通用配置，适用于所有VIM编辑器及插件

" 非兼容模式
set nocompatible

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                   界面                                     "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" 开启折叠
set wrap
" 显示行号
set number
" 显示光标位置
set ruler
" 改变超过 80 个字符之后的区域，这样就可以起到提示作用
set colorcolumn=81 " 突出显示第81列
" 错误格式
set errorformat+=[%f:%l]\ ->\ %m,[%f:%l]:%m
" 显示最后一行
set display+=lastline
" 设置不可见字符显示样式
set listchars=tab:▸\ ,eol:¬
" 该功能会导致nvim极度卡顿
" 高亮当前行
"set cursorline
" 默认开启语法高亮
if has('syntax')
	syntax enable
	syntax on
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                   查看                                     "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" 搜索设置
set ignorecase
set smartcase
set incsearch
set hlsearch
" 代码折叠
if has('folding')
	" 允许代码折叠
	set foldenable

	" 代码折叠默认使用缩进
    set foldmethod=manual

	" 默认打开所有缩进
	set foldlevel=99
endif
" 搜索忽略名单
set suffixes=.bak,~,.o,.h,.info,.swp,.obj,.pyc,.pyo,.egg-info,.class

set wildignore=*.o,*.obj,*~,*.exe,*.a,*.pdb,*.lib "stuff to ignore when tab completing
set wildignore+=*.so,*.dll,*.swp,*.egg,*.jar,*.class,*.pyc,*.pyo,*.bin,*.dex
set wildignore+=*.zip,*.7z,*.rar,*.gz,*.tar,*.gzip,*.bz2,*.tgz,*.xz    " MacOSX/Linux
set wildignore+=*DS_Store*,*.ipch
set wildignore+=*.gem
set wildignore+=*.png,*.jpg,*.gif,*.bmp,*.tga,*.pcx,*.ppm,*.img,*.iso
set wildignore+=*.so,*.swp,*.zip,*/.Trash/**,*.pdf,*.dmg,*/.rbenv/**
set wildignore+=*/.nx/**,*.app,*.git,.git
set wildignore+=*.wav,*.mp3,*.ogg,*.pcm
set wildignore+=*.mht,*.suo,*.sdf,*.jnlp
set wildignore+=*.chm,*.epub,*.pdf,*.mobi,*.ttf
set wildignore+=*.mp4,*.avi,*.flv,*.mov,*.mkv,*.swf,*.swc
set wildignore+=*.ppt,*.pptx,*.docx,*.xlt,*.xls,*.xlsx,*.odt,*.wps
set wildignore+=*.msi,*.crx,*.deb,*.vfd,*.apk,*.ipa,*.bin,*.msu
set wildignore+=*.gba,*.sfc,*.078,*.nds,*.smd,*.smc
set wildignore+=*.linux2,*.win32,*.darwin,*.freebsd,*.linux,*.android

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                   编辑                                     "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Tab
set expandtab
set softtabstop=4
set shiftwidth=4
set tabstop=4
" 缩进设置，设置基于文件的类型的缩进
set autoindent
set cindent
set cino=(0,W4
if has('autocmd')
	filetype plugin indent on
endif
" 按键延时检测
set ttimeout
set ttimeoutlen=50
" 支持中文
set fo+=mB
" 括号匹配
set showmatch
set matchtime=2
" 删除设置
set backspace=eol,start,indent

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                   文件                                     "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" 切换缓冲区文件可以不保存当前文件
set hidden
" 自动载入外部修改
set autoread
" 编码设置
if has('multi_byte')
    set encoding=utf-8
    set fileencoding=utf-8
    set fileencodings=ucs-bom,utf-8,gbk,gb18030,big5,euc-jp,latin1
    set fileformat=unix
    set fileformats=unix,dos
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                   其他                                     "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Windows 禁用 ALT 操作菜单（使得 ALT 可以用到 Vim里）
set winaltkeys=no

" 智能补全命令行
set wildmenu
set wildmode=full

" 延迟绘制
set lazyredraw

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                 快捷键                                     "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"绑定大写的 HL 为行首和行尾的快捷键
noremap H ^
noremap L $
" Alt+j/k 逻辑跳转下一行/上一行
noremap <m-j> gj
noremap <m-k> gk
" 命令行模式光标移动
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
" 清除高亮
nnoremap <silent> <Backspace> :nohl<CR>
