# for zsh

export EDITOR="vim"

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=240'

export CHEATCOLORS=true

case "$(uname -s)" in 
Darwin)
    eval `gdircolors ~/.dir_colors`
    ;;
Linux)
    eval `dircolors ~/.dir_colors`
    ;;
*)
    ;;
esac

#Use vi style
function zle-line-init zle-keymap-select {
    RPS1="${${KEYMAP/vicmd/-- NORMAL --}/(main|viins)/-- INSERT --}"
    RPS2=$RPS1
    zle reset-prompt
}
zle -N zle-line-init
zle -N zle-keymap-select

# 按键延时为1ms
export KEYTIMEOUT=1

# 禁用Ctrl-s锁住终端
stty -ixon

export ANDROID_HOME=$HOME/Android/Sdk

export ANDROID_NDK_HOME=$HOME/Android/Sdk/ndk/16.1.4479499

export LIBVA_DRIVER_NAME=iHD
export GOPATH=$HOME/go

export PATH=$PATH:$HOME/Application:$GOPATH/bin

function mkcd() { mkdir -p "$@" && cd "$@"; }

function gi() { curl -sLw n https://www.gitignore.io/api/$@ | tee -a .gitignore;}

function caps() { setxkbmap -option ctrl:nocaps; xcape -e 'Control_L=Escape' }
