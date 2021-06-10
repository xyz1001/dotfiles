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

if empty(glob('~/.vim/autoload/plug.vim')) && !has('win32')
    if has('win32')
        silent execute "!curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
    else
        silent execute "!iwr -useb https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim |`ni $HOME/vimfiles/autoload/plug.vim -Force"
    endif
    autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

""""""""""""""""""""""""""""""""""""
"             插件列表             "
""""""""""""""""""""""""""""""""""""

call plug#begin('~/.vim/plugged')

" 外观
Plug 'flazz/vim-colorschemes'
Plug 'vim-airline/vim-airline' | Plug 'vim-airline/vim-airline-themes'
Plug 'edkolev/tmuxline.vim'

" 窗口
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin' | Plug 'ryanoasis/vim-devicons'
Plug 'christoomey/vim-tmux-navigator'
Plug 'mhinz/vim-startify'
Plug 'tpope/vim-fugitive'
Plug 'rhysd/committia.vim'
Plug 'Valloric/ListToggle'
Plug 'ZhiyuanLck/vim-float-terminal'
Plug 'chrisbra/Recover.vim'

" 编辑
Plug 'RRethy/vim-illuminate'
Plug 'bronson/vim-trailing-whitespace'
Plug 'lilydjwg/fcitx.vim'
Plug 'google/vim-searchindex'
Plug 'kana/vim-textobj-user'
Plug 'kana/vim-textobj-function'
Plug 'kana/vim-textobj-indent'
Plug 'kana/vim-textobj-line'
Plug 'lucapette/vim-textobj-underscore'
Plug 'sgur/vim-textobj-parameter'
Plug 'terryma/vim-expand-region'
Plug 'junegunn/vim-easy-align'
Plug 'vim-scripts/ReplaceWithRegister'
Plug 'vim-scripts/VisIncr'
Plug 'ianva/vim-youdao-translater'
Plug 'mzlogin/vim-markdown-toc', {'for': ['markdown']}
Plug 'easymotion/vim-easymotion'
Plug 'kshenoy/vim-signature'
Plug 'airblade/vim-gitgutter'
Plug 'mg979/vim-visual-multi', {'branch': 'master'}
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'sheerun/vim-polyglot'
Plug 'dyng/ctrlsf.vim'

" 开发
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
Plug 'sbdchd/neoformat'
Plug 'scrooloose/nerdcommenter'
Plug 'vim-scripts/DoxygenToolkit.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" 外部
Plug 'xyz1001/WebSearch.vim'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
Plug 'vim-scripts/vim-nerdtree_plugin_open'
Plug 'weirongxu/plantuml-previewer.vim'

call plug#end()

""""""""""""""""""""""""""""""""""""""""""
"                VIM配置                 "
""""""""""""""""""""""""""""""""""""""""""


source ~/.vim/config/vim/vimbase.vim
source ~/.vim/config/vim/vim-editor.vim

" +++++++++++++++++++++++++++++++++++++++
" +              插件配置               +
" +++++++++++++++++++++++++++++++++++++++

" 外观
source ~/.vim/config/plugin/colorscheme.vim
source ~/.vim/config/plugin/airline.vim
source ~/.vim/config/plugin/tmuxline.vim

" 窗口
source ~/.vim/config/plugin/nerdtree.vim
source ~/.vim/config/plugin/committia.vim
source ~/.vim/config/plugin/vim-float-terminal.vim

" 编辑
source ~/.vim/config/plugin/vim-easy-align.vim
source ~/.vim/config/plugin/youdao-translater.vim
source ~/.vim/config/plugin/easymotion.vim
source ~/.vim/config/plugin/vim-visual-multi.vim
source ~/.vim/config/plugin/ctrlsf.vim

" 开发
source ~/.vim/config/plugin/ultisnips.vim
source ~/.vim/config/plugin/neoformat.vim
source ~/.vim/config/plugin/nerdcommenter.vim
source ~/.vim/config/plugin/doxygentoolkit.vim
source ~/.vim/config/plugin/vim-polyglot.vim
source ~/.vim/config/plugin/coc.vim
