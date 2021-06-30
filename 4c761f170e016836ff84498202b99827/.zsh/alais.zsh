#zsh custom alias

alias o="xdg-open"

#show date and time for shell history
alias history="fc -il 1"
alias make="make -j8"
alias cdbuild="if [ -d \"./build\" ]; then cd build; else mkdir build && cd build; fi"

command -v aria2c &> /dev/null && alias aria2="aria2c --conf=$HOME/.aria2/aria2.conf"

command -v fuck &> /dev/null && eval $(thefuck --alias) && alias fix="fuck"
command -v bat &> /dev/null && alias cat="bat"
command -v proxychains4 &> /dev/null && alias ss="proxychains4 -q "
command -v trash-put &> /dev/null && alias rm="echo 'Dangerous command, trash-put instead automatically' && trash-put"
command -v lsd &> /dev/null && alias ls="lsd"
command -v cht.sh &> /dev/null && alias cht="cht.sh"
command -v dust &> /dev/null && alias du="dust"
command -v duf &> /dev/null && alias df="duf"
command -v btm &> /dev/null && alias top="btm"
