" VIM编辑器配置

" leader键
let mapleader = ' '
" 开启鼠标
set mouse=a
" 消息输出窗口高j
set cmdheight=2
" 终端色彩
set termguicolors
" 禁用交换文件
set noswapfile
" 自动备份
set backup
set writebackup
set backupext=.bak
set updatetime=4000
if !isdirectory($HOME."/.vim/backup")
    call mkdir($HOME."/.vim/backup", "p", 0700)
endif
set backupdir=~/.vim/backup/
" 开启保存 undo 历史功能
set undofile
if !isdirectory($HOME."/.vim/undo")
    call mkdir($HOME."/.vim/undo", "p", 0700)
endif
set undodir=~/.vim/undo/

" 使用 %% 扩展当前文件的路径
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'

" 将光标设为上次退出时的位置
autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

" Windows powershell 终端设置
if has('win32')
  set shell=pwsh\ -NoLogo shellpipe=\| shellxquote=
  set shellcmdflag=-NoLogo\ -NoProfile\ -ExecutionPolicy\ RemoteSigned\ -Command
  set shellredir=\|\ Out-File\ -Encoding\ UTF8
endif

" 清空背景色，支持透明背景
autocmd ColorScheme * highlight Normal ctermbg=NONE guibg=NONE

autocmd BufNewFile,BufFilePre,BufRead *.qss set filetype=css
autocmd BufNewFile,BufFilePre,BufRead *.ts set filetype=xml
autocmd BufNewFile,BufFilePre,BufRead *.ui set filetype=xml
autocmd BufNewFile,BufFilePre,BufRead *.qrc set filetype=xml
autocmd BufNewFile,BufFilePre,BufRead *.mm set filetype=objc
autocmd BufNewFile,BufFilePre,BufRead *.m set filetype=objcpp
