" VIM编辑器配置

" 开启鼠标
set mouse=a

set updatetime=300

set nobackup
set nowritebackup

if has('win32')
    let &shell = has('win32') ? 'powershell' : 'pwsh'
    let &shellcmdflag = '-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;'
    let &shellredir = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
    let &shellpipe = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
    set shellquote= shellxquote=
endif

" 修改leader键
let mapleader = ';'
let maplocalleader = ','

" 使用+ -代替被占用的; ,的功能
noremap + ;
noremap - ,

" 开启保存 undo 历史功能
set undofile
" undo 历史保存路径
if !isdirectory($HOME."/.undo_history")
    call mkdir($HOME."/.undo_history", "", 0700)
endif
set undodir=~/.undo_history/

" 使用 %% 扩展当前文件的路径
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'

" 将光标设为上次退出时的位置
autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

autocmd BufNewFile,BufFilePre,BufRead *.qss set filetype=css
autocmd BufNewFile,BufFilePre,BufRead *.ts set filetype=xml
autocmd BufNewFile,BufFilePre,BufRead *.ui set filetype=xml
autocmd BufNewFile,BufFilePre,BufRead *.qrc set filetype=xml
