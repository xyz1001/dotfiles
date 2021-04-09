" ++++++++++++++++++++++++++++++++++++++++
" +         name: .vimrc                 +
" +         author: steven guo           +
" +         last update: 2016-03-20      +
" +                                      +
" +         author: 张帆(Zix)            +
" +         last update: 2017-04-08      +
" ++++++++++++++++++++++++++++++++++++++++


" ++++++++++++++++++++++++++++++++++++++++
" +             常用插件安装             +
" ++++++++++++++++++++++++++++++++++++++++

" enable matchit
runtime macro/matchit.vim

if empty(glob('~/.vim/autoload/plug.vim')) && !has('win32')
    silent execute "!curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
    autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

Plug 'RRethy/vim-illuminate'
Plug 'jiangmiao/auto-pairs'
Plug 'Shougo/echodoc.vim'
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
Plug 'Valloric/YouCompleteMe'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'airblade/vim-gitgutter'
Plug 'aklt/plantuml-syntax'
Plug 'altercation/vim-colors-solarized'
Plug 'bronson/vim-trailing-whitespace'
Plug 'chrisbra/Recover.vim'
Plug 'christoomey/vim-tmux-navigator'
Plug 'ctrlpvim/ctrlp.vim' | Plug 'tacahiroy/ctrlp-funky'
Plug 'derekwyatt/vim-fswitch', {'for': ['cpp', 'c']}
Plug 'dyng/ctrlsf.vim'
Plug 'easymotion/vim-easymotion'
Plug 'edkolev/tmuxline.vim'
Plug 'embear/vim-foldsearch'
Plug 'flazz/vim-colorschemes'
Plug 'google/vim-searchindex'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & yarn install'  }
Plug 'mzlogin/vim-markdown-toc'
Plug 'ianva/vim-youdao-translater'
Plug 'ivalkeen/vim-ctrlp-tjump'
Plug 'junegunn/vim-easy-align'
Plug 'kana/vim-textobj-function'
Plug 'kana/vim-textobj-indent', {'for': 'python'}
Plug 'kana/vim-textobj-line'
Plug 'kana/vim-textobj-user'
Plug 'kshenoy/vim-signature'
Plug 'lucapette/vim-textobj-underscore', {'for': ['python', 'cpp', 'c']}
Plug 'ludovicchabant/vim-gutentags'
Plug 'majutsushi/tagbar'
Plug 'mhinz/vim-startify'
Plug 'mileszs/ack.vim'
Plug 'plasticboy/vim-markdown', {'for': ['markdown']}
Plug 'rdnetto/YCM-Generator', { 'branch': 'stable'}
Plug 'rhysd/clever-f.vim'
Plug 'rhysd/committia.vim'
Plug 'ryanoasis/vim-devicons'
Plug 'sbdchd/neoformat'
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/nerdtree'
"Plug 'scrooloose/vim-slumlord'
Plug 'sgur/vim-textobj-parameter'
Plug 'skywind3000/asyncrun.vim'
Plug 'terryma/vim-expand-region'
"Plug 'terryma/vim-multiple-cursors'
Plug 'mg979/vim-visual-multi', {'branch': 'master'}
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'tyru/open-browser.vim'
Plug 'vim-airline/vim-airline' | Plug 'vim-airline/vim-airline-themes'
Plug 'vim-scripts/DoxygenToolkit.vim'
Plug 'vim-scripts/ReplaceWithRegister'
Plug 'vim-scripts/VisIncr'
Plug 'lilydjwg/fcitx.vim'
Plug 'vim-scripts/vim-nerdtree_plugin_open'
Plug 'w0rp/ale'
Plug 'weirongxu/plantuml-previewer.vim'
Plug 'xyz1001/WebSearch.vim'
Plug 'zhaohuaxishi/vim-ctrlp-cmdpalette'
Plug 'Valloric/ListToggle'
Plug 'mtdl9/vim-log-highlighting'
Plug 'fatih/vim-go', { 'tag': '*' }
Plug 'sheerun/vim-polyglot', {'commit':'81ada11'} " 必须在vim-go之后
Plug 'dgryski/vim-godef'
Plug 'ZhiyuanLck/vim-float-terminal'

" Add plugins to &runtimepath
call plug#end()

" Put your non-Plugin stuff after this line

source ~/.vim/pluginconfig/vimcommon.vim

" +++++++++++++++++++++++++++++++++++++++
" +              插件配置               +
" +++++++++++++++++++++++++++++++++++++++

source ~/.vim/pluginconfig/ack.vim
source ~/.vim/pluginconfig/airline.vim
source ~/.vim/pluginconfig/colorscheme.vim
source ~/.vim/pluginconfig/ctrlp.vim
source ~/.vim/pluginconfig/ctrlsf.vim
source ~/.vim/pluginconfig/doxygentoolkit.vim
source ~/.vim/pluginconfig/fugitive.vim
source ~/.vim/pluginconfig/nerdtree.vim
source ~/.vim/pluginconfig/tagbar.vim
source ~/.vim/pluginconfig/vim-visual-multi.vim
source ~/.vim/pluginconfig/tmuxline.vim
source ~/.vim/pluginconfig/ultisnips.vim
source ~/.vim/pluginconfig/visual-star.vim
source ~/.vim/pluginconfig/youcompleteme.vim
source ~/.vim/pluginconfig/fswitch.vim
source ~/.vim/pluginconfig/markdown.vim
source ~/.vim/pluginconfig/vim-gutentags.vim
source ~/.vim/pluginconfig/easymotion.vim
source ~/.vim/pluginconfig/nerdcommenter.vim
source ~/.vim/pluginconfig/rootignore.vim
source ~/.vim/pluginconfig/neoformat.vim
source ~/.vim/pluginconfig/vim-easy-align.vim
source ~/.vim/pluginconfig/ale.vim
source ~/.vim/pluginconfig/youdao-translater.vim
source ~/.vim/pluginconfig/asyncrun.vim
source ~/.vim/pluginconfig/echodoc.vim
source ~/.vim/pluginconfig/committia.vim
source ~/.vim/pluginconfig/vim-float-terminal.vim
