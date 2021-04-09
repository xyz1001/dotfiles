" unite "
"""""""""

call unite#custom#profile('default', 'context', {
    \   'start_insert': 1,
    \   'winheight': 15,
    \   'prompt': ">>> ",
    \   'direction': 'botright',
    \ })

let g:unite_source_menu_menus = {}
let g:unite_source_menu_menus.main = {
    \ 'description' : 'main menus for daliy work',
    \}
let g:unite_source_menu_menus.main.command_candidates = [
        \[' + (e)dit vimrc'       , 'e $MYVIMRC']  ,
        \[' + (q)uit & save'      , 'x']           ,
        \[' + (s)ource (v)imrc'   , 'so $MYVIMRC'] ,
        \[' + (s)ource curren(t)' , 'so %']        ,
        \[' + (f)ormat (c)ode'    , 'FormatCode']  ,
        \[' + (f)ormat (l)ine'    , 'FormatLines'] ,
        \[' + (p)lugin in(s)tall' , 'PlugInstall'] ,
        \[' + (p)lugin u(p)date'  , 'PlugUpdate']  ,
        \[' + (p)lugin (c)lean'   , 'PlugClean']   ,
        \[' + (t)oogle n(u)mber'  , 'set number!'] ,
    \]

" for fuzzy match
call unite#filters#matcher_default#use(['matcher_fuzzy'])

nnoremap <silent> <C-m> :Unite -buffer-name=mainmenu menu:main <CR>
nnoremap <silent> <C-j> :Unite -buffer-name=autojump autojump <CR>
