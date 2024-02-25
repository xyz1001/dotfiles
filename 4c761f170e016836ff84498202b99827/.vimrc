" ++++++++++++++++++++++++++++++++++++++++
" +         name: .vimrc                 +
" +         author: steven guo           +
" +         last update: 2016-03-20      +
" +                                      +
" +         author: 张帆(Zix)            +
" +         last update: 2017-04-08      +
" ++++++++++++++++++++++++++++++++++++++++


" ++++++++++++++++++++++++++++++++++++++++
" +             插件管理器               +
" ++++++++++++++++++++++++++++++++++++++++

" enable matchit
runtime macro/matchit.vim

if empty(glob('$HOME/.vim/autoload/plug.vim'))
    if has('win32')
        execute '!powershell "iwr -useb https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim |` ni $HOME/.vim/autoload/plug.vim -Force"'
    else
        execute "!curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
    endif
    autocmd VimEnter * PlugInstall | source $MYVIMRC
endif


""""""""""""""""""""""""""""""""""""
"             插件列表             "
""""""""""""""""""""""""""""""""""""

call plug#begin('~/.vim/plugged')

" 外观
if exists('$TMUX')
    " 修改statusline配色后启用该插件生成tmuxline配色文件
    " Plug 'edkolev/tmuxline.vim'
endif


" 编辑
if has('win32')
    Plug 'zhaosheng-pan/vim-im-select'
endif
Plug 'vim-scripts/ReplaceWithRegister'
Plug 'vim-scripts/VisIncr'
Plug 'ianva/vim-youdao-translater'
Plug 'mzlogin/vim-markdown-toc', {'for': ['markdown']}
Plug 'easymotion/vim-easymotion'
Plug 'airblade/vim-gitgutter'
Plug 'mg979/vim-visual-multi', {'branch': 'master'}
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'sheerun/vim-polyglot'
Plug 'dyng/ctrlsf.vim'
Plug 'mileszs/ack.vim'
Plug 'ngg/vim-gn'
Plug 'psliwka/vim-smoothie'
Plug 'simnalamburt/vim-mundo'
Plug 'editorconfig/editorconfig-vim'

" 开发
Plug 'honza/vim-snippets'
Plug 'sbdchd/neoformat'
Plug 'vim-scripts/DoxygenToolkit.vim'
Plug 'neoclide/coc.nvim'
Plug 'liuchengxu/vista.vim'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'tyru/caw.vim'
Plug 'github/copilot.vim'

" 外部
Plug 'xyz1001/WebSearch.vim'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
Plug 'tyru/open-browser.vim' | Plug 'weirongxu/plantuml-previewer.vim'

" 运行
Plug 'skywind3000/asynctasks.vim'
Plug 'skywind3000/asyncrun.vim'
Plug 'skywind3000/asyncrun.extra'

call plug#end()

""""""""""""""""""""""""""""""""""""""""""
"                VIM配置                 "
""""""""""""""""""""""""""""""""""""""""""


source ~/.vim/config/vim/vim-base.vim
source ~/.vim/config/vim/vim-editor.vim

" +++++++++++++++++++++++++++++++++++++++
" +              插件配置               +
" +++++++++++++++++++++++++++++++++++++++

" 外观
source ~/.vim/config/plugin/colorscheme.vim
source ~/.vim/config/plugin/lightline.vim
if exists('$TMUX')
    " source ~/.vim/config/plugin/tmuxline.vim
endif

" 窗口
source ~/.vim/config/plugin/committia.vim
source ~/.vim/config/plugin/vim-floaterm.vim
source ~/.vim/config/plugin/telescope.vim

" 编辑
source ~/.vim/config/plugin/vim-easy-align.vim
source ~/.vim/config/plugin/youdao-translater.vim
source ~/.vim/config/plugin/easymotion.vim
source ~/.vim/config/plugin/vim-visual-multi.vim
source ~/.vim/config/plugin/ctrlsf.vim
source ~/.vim/config/plugin/ack.vim
source ~/.vim/config/plugin/vim-mundo.vim

" 开发
source ~/.vim/config/plugin/neoformat.vim
source ~/.vim/config/plugin/doxygentoolkit.vim
source ~/.vim/config/plugin/vim-polyglot.vim
source ~/.vim/config/plugin/coc.vim
source ~/.vim/config/plugin/vista.vim
source ~/.vim/config/plugin/caw.vim

" 运行
source ~/.vim/config/plugin/asyncrun.vim
source ~/.vim/config/plugin/asynctasks.vim
