#zsh custom alias
alias o="xdg-open"
alias cpplintall='find . -name "*.h" -or -name "*.cpp" -or -name "*.cc" -or -name "*.hpp" -or -name "*.c" | xargs cpplint 2>&1 | ag -v "Ignor"'

#show date and time for shell history
alias history="fc -il 1"
alias aria2="aria2c --conf=/home/zix/.aria2/aria2.conf"

eval $(thefuck --alias)
alias fix="fuck"

alias make="make -j8"

alias cat="bat"


alias cdbuild="if [ -d \"./build\" ]; then cd build; else mkdir build && cd build; fi"

alias ss="proxychains4 -q "

alias tp="trash-put"
alias te="trash-empty"
alias rm="echo 'Dangerous command, trash-put instead automatically' && trash-put"
alias ls="lsd"
alias cht="cht.sh"
