" youcompleteme "
"""""""""""""""""

let g:ycm_global_ycm_extra_conf="~/.vim/pluginconfig/.ycm_extra_conf.py"

set completeopt=longest,menu

"离开插入模式后自动关闭预览窗口
autocmd InsertLeave * if pumvisible() == 0|pclose|endif

" 不显示开启vim时检查ycm_extra_conf文件的信息
let g:ycm_confirm_extra_conf=0

" 开启基于tag的补全，可以在这之后添加需要的标签路径
let g:ycm_collect_identifiers_from_tags_files=1

"注释和字符串中的文字也会被收入补全
let g:ycm_collect_identifiers_from_comments_and_strings = 1

" 输入第2个字符开始补全
let g:ycm_min_num_of_chars_for_completion=2
let g:ycm_min_num_identifier_candidate_chars = 2

" 禁止缓存匹配项,每次都重新生成匹配项
let g:ycm_cache_omnifunc=1

" 开启语义补全
let g:ycm_seed_identifiers_with_syntax=1

"在注释输入中也能补全
let g:ycm_complete_in_comments = 1

"在字符串输入中也能补全
let g:ycm_complete_in_strings = 1

" 设置在下面几种格式的文件上屏蔽ycm
let g:ycm_filetype_blacklist = {
            \ 'tagbar' : 1,
            \ 'nerdtree' : 1,
            \ 'startify' : 1,
            \}

nnoremap  <Leader>x :YcmCompleter FixIt<cr>
nnoremap  <Leader>i :YcmCompleter GoToInclude<cr>

let g:ycm_error_symbol = "✖"
let g:ycm_warning_symbol ="➠"

let g:tmuxcomplete#trigger = 'omnifunc'
let g:ycm_server_log_level = 'info'

let g:ycm_semantic_triggers =  {
            \ 'c,cpp,python,java,go,erlang,perl': ['re!\w{2}'],
            \ 'cs,lua,javascript': ['re!\w{2}'],
            \ }

let g:ycm_filetype_whitelist = {
			\ "c":1,
			\ "cpp":1,
			\ "h":1,
			\ "hpp":1,
			\ "go":1,
			\ "objc":1,
			\ "sh":1,
			\ "zsh":1,
			\ "zimbu":1,
			\ "python":1,
			\ "cmake":1,
			\ "qmake":1,
			\ "css":1,
			\ }
