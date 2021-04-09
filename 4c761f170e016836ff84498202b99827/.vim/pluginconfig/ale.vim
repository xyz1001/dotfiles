"始终开启标志列
let g:ale_sign_column_always = 1
let g:ale_set_highlights = 0
"推出插入模式后lint
let g:ale_lint_on_text_changed = 'normal'
let g:ale_lint_on_insert_leave = 1
"设置标识符号
let g:ale_sign_error = "✖"
let g:ale_sign_warning = "➠"
"显示Linter名称,出错或警告等相关信息
let g:ale_echo_msg_error_str = 'Error'
let g:ale_echo_msg_warning_str = 'Warning'
let g:ale_echo_msg_format = '[%linter%] %code: %%s [%severity%]'
"Linter选项
let g:ale_linters_explicit = 1
let g:ale_linters = {
          \ 'sh' : ['shellcheck'],
          \ 'c': ['cpplint'],
          \ 'cpp': ['cpplint', 'cppcheck'],
          \ 'html' : ['tidy'],
          \ 'python' : ['flake8'],
          \ 'markdown' : ['mdl'],
          \ 'javascript' : ['eslint'],
          \ 'json' : ['jsonlint'],
          \}
let g:ale_cpp_cpplint_options = '--filter=-whitespace/indent,-build/c++11,-build/include,-runtime/references -build/header_guard'
let g:ale_cpp_cppcheck_options = '--enable=all'
let g:ale_python_flake8_options = '--max-line-length=80'
let g:ale_markdown_mdl_options = '-r \~MD029,\~MD013 -w'
