#######################################################################
#                             platform                                #
#######################################################################

source $HOME/.zsh/$(uname -s)/config.zsh

#######################################################################
#                               export                                #
#######################################################################

export EDITOR="nvim"

export CHEATCOLORS=true
export COLORTERM=truecolor

export GOPATH=$HOME/go

# 按键延时为1ms
export KEYTIMEOUT=1

export LIBVA_DRIVER_NAME=iHD

export MAKEFLAGS=-j$(nproc)

export NVM_DIR="$HOME/.nvm"

export PIP_BREAK_SYSTEM_PACKAGES=1

export PATH=$HOME/Application:$GOPATH/bin:$HOME/.yarn/bin:$HOME/.local/bin:$PATH

#######################################################################
#                                alias                                #
#######################################################################

alias history="fc -il 1"

command -v xdg-open &> /dev/null && alias o="xdg-open"
command -v open &> /dev/null && alias o="open"
command -v termux-open &> /dev/null && alias o="termux-open"
command -v aria2c &> /dev/null && alias aria2="aria2c --conf=$HOME/.aria2/aria2.conf"
command -v fuck &> /dev/null && eval $(thefuck --alias) && alias fix="fuck"
command -v bat &> /dev/null && alias cat="bat"
command -v proxychains4 &> /dev/null && alias ss="proxychains4 -q "
command -v lsd &> /dev/null && alias ls="lsd"
command -v cht.sh &> /dev/null && alias cht="cht.sh"
command -v dust &> /dev/null && alias du="dust"
command -v duf &> /dev/null && alias df="duf"
command -v btm &> /dev/null && alias top="btm"


#######################################################################
#                               bindkey                               #
#######################################################################

bindkey '^O' clear-screen

bindkey "^p" history-beginning-search-backward
bindkey "^n" history-beginning-search-forward

#######################################################################
#                              function                               #
#######################################################################

function mkcd() { mkdir -p "$@" && cd "$@"; }

function gi() { curl -sLw n https://www.gitignore.io/api/$@ | tee -a .gitignore;}

function cdbuild() { if [ -d "./build" ]; then cd build; else mkdir build && cd build; fi }

#######################################################################
#                                misc                                 #
#######################################################################

[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" --no-use  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=240'

#Use vi style
function zle-line-init zle-keymap-select {
    RPS1="${${KEYMAP/vicmd/-- NORMAL --}/(main|viins)/-- INSERT --}"
    RPS2=$RPS1
    zle reset-prompt
}
zle -N zle-line-init
zle -N zle-keymap-select

# 禁用Ctrl-s锁住终端
stty -ixon
