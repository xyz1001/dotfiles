source $HOME/.zsh/antigen.zsh

antigen use oh-my-zsh

#antigen theme robbyrussell
antigen theme agnoster
#antigen theme jreese
#antigen theme arrow

antigen bundle git
antigen bundle extract
antigen bundle colored-man-pages
antigen bundle git
antigen bundle pip
antigen bundle command-not-found
antigen bundle vi-mode
antigen bundle docker
antigen bundle docker-compose
antigen bundle paulirish/git-open

antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-completions
antigen bundle zsh-users/zsh-syntax-highlighting

antigen apply

eval "$(zoxide init zsh)"

source $HOME/.zsh/config.zsh

if [[ -f $HOME/.config/secret.env ]]; then
    if file -L -b $HOME/.config/secret.env | grep -q "ASCII\|text"; then
        set -a
        source $HOME/.config/secret.env
        set +a
    fi
fi
