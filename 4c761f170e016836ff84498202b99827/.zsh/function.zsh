function mkcd() { mkdir -p "$@" && cd "$@"; }

function gi() { curl -sLw n https://www.gitignore.io/api/$@ | tee -a .gitignore;}

function caps() { setxkbmap -option ctrl:nocaps; xcape -e 'Control_L=Escape' }

function cdbuild() { if [ -d "./build" ]; then cd build; else mkdir build && cd build; fi }
