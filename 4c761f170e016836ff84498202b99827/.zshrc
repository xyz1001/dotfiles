source $HOME/.zsh/antigen.zsh

antigen use oh-my-zsh

antigen theme robbyrussell
#antigen theme Honukai
#antigen theme agnoster
#antigen theme jreese
#antigen theme arrow

antigen bundle git
antigen bundle extract
antigen bundle colored-man-pages
antigen bundle git
antigen bundle sudo
antigen bundle pip
antigen bundle command-not-found
antigen bundle vi-mode
antigen bundle skywind3000/z.lua

antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-completions src
antigen bundle zsh-users/zsh-syntax-highlighting

antigen apply

source $HOME/.zsh/config.zsh
source $HOME/.zsh/bindkey.zsh
source $HOME/.zsh/alais.zsh
source $HOME/.zsh/function.zsh
