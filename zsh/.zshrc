. ~/dotfiles/aliases.sh
. ~/dotfiles/functions.sh
. ~/dotfiles/env.sh

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory

unsetopt global_rcs

# enable C-s forward search
[[ $- == *i* ]] && stty -ixon


# enable up down history and place cursor at end of text
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search
bindkey "^[[B" down-line-or-beginning-search

{
    syntax_highlighting="/usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
    
    if [[ -f ${syntax_highlighting} ]]; then
        . "${syntax_highlighting}"
    else
        echo "Missing zsh-syntax-highlighting, install with package manager (brew)"
    fi
}

# Load and initialize the completion system ignoring insecure directories with a
# cache time of 20 hours, so it should almost always regenerate the first time a
# shell is opened each day.
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
    RPROMPT="$(git_status) %F{blue}] %F{green}%D{%L:%M} %F{yellow}%D{%p}%f"
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
