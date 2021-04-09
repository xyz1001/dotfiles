inoremap <silent><expr> ( complete_parameter#pre_complete("()")
smap <c-j> <Plug>(complete_parameter#goto_next_parameter)
imap <c-j> <Plug>(complete_parameter#goto_next_parameter)
smap <c-k> <Plug>(complete_parameter#goto_previous_parameter)
imap <c-k> <Plug>(complete_parameter#goto_previous_parameter))

imap <C-p> <Plug>(complete_parameter#overload_down)
smap <C-p> <Plug>(complete_parameter#overload_down)

imap <C-n> <Plug>(complete_parameter#overload_up)
smap <C-n> <Plug>(complete_parameter#overload_up)
