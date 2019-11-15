source "${ZDOTDIR}/functions.sh"

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory

# enable C-s forward search
[[ $- == *i* ]] && stty -ixon

bindkey "^[[A" history-beginning-search-backward
bindkey "^[[B" history-beginning-search-forward

SYNTAX_HIGHLIGHTING="/usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

if [[ -f ${SYNTAX_HIGHLIGHTING} ]]; then
    source "${SYNTAX_HIGHLIGHTING}"
else
    echo "Missing zsh-syntax-highlighting, install with package manager (brew, pacman, etc)"
fi

autoload -U compinit && compinit

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# set color to always so that output will not include color control characters when redirecting or piping
export GREP_OPTIONS='--color=auto'

# keep history between iex sessions
export ERL_AFLAGS="-kernel shell_history enabled"

# add dynamic prompt here
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
