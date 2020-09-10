# set color to always so that output will not include color control characters when redirecting or piping
export CLICOLOR=1

# set auto so that it colors to tty but not when redirecting and piping
export GREP_OPTIONS='--color=auto'

export EDITOR="vim"

bind '"\t":menu-complete'
bind '"\e[Z":menu-complete-backward'
bind "set show-all-if-ambiguous on"
bind "set completion-ignore-case on"
bind 'set match-hidden-files off'
bind "set menu-complete-display-prefix on"

# partial match input on up and down through history
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

# enable C-s forward search
[[ $- == *i* ]] && stty -ixon

function prompt_left() {
  echo -e "\033[0;92m\w\033[0m \033[0;94m\\033[0m"
}

function prompt() {
    PS1=$(printf "%s\n-> " "$(prompt_left)")
}

# set title bar: username | pwd
PROMPT_COMMAND='echo -ne "\033]0;${USER} | ${PWD}\007"'
prompt

