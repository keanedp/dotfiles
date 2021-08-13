. ~/dotfiles/aliases.sh
. ~/dotfiles/functions.sh
. ~/dotfiles/env.sh

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory

# disable reading /etc/zsh* config files
unsetopt global_rcs

# use emacs keybindings
bindkey -e

# enable C-s forward search
[[ $- == *i* ]] && stty -ixon

# enable up down history and place cursor at end of text
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search
bindkey "^[[B" down-line-or-beginning-search

if [[ $(uname) = "Darwin" ]]; then
    syntax_highlighting="/usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
else
    syntax_highlighting="/usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

if [[ -f ${syntax_highlighting} ]]; then
    . "${syntax_highlighting}"
else
    echo "Missing zsh-syntax-highlighting, install with package manager (brew)"
fi

# initialize completion system, caching for 20 hours
autoload -Uz compinit
comp_files=(${ZDOTDIR}/.zcompdump(Nm-20))
if (( $#comp_files )); then
    compinit -i -C
else
    compinit -i
fi
unset comp_files

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# dynamic prompt
precmd () {
    print -Pn "\e]2;%n | %~\a" # set title bar: username | pwd
    RPROMPT="%F{yellow}$(git_status) %F{blue}] %F{green}%D{%L:%M} %F{yellow}%D{%p}%f"
}

setopt prompt_subst
PROMPT='%F{green}%2c%F{blue} [%f '

# add direnv hook
if command -v direnv >/dev/null 2>/dev/null; then
    eval "$(direnv hook zsh)"
fi

# local system settings, not under source control
for f in $ZDOTDIR/.zshrc_local/*.sh; do
    . $f
done 2> /dev/null
