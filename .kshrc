HISTFILE="$HOME/.ksh_history"
HISTSIZE=5000

. ~/dotfiles/aliases.sh
. ~/dotfiles/functions.sh
. ~/dotfiles/env.sh

export VISUAL="emacs"
export EDITOR="emacs"
set -o emacs
#alias __A=$(print '\0020') # ^P = up = previous command
#alias __B=$(print '\0016') # ^N = down = next command

# git completions
set -A complete_git_1 -- \
	$(git --list-cmds=main) \
	$(git config --get-regexp ^alias\. | awk -F '[\. ]' '{ print $2 }')

# ssh completions
read_known_hosts() {
        local _file=$1 _line _host

        while read _line ; do
          _line=${_line%%#*} # delete comments
          _line=${_line%%@*} # ignore markers
          _line=${_line%% *} # keep only host field

          [[ -z $_line ]] && continue

          local IFS=,
          for _host in $_line; do
            _host=${_host#\[}
            _host=${_host%%\]*}
            for i in ${HOST_LIST[*]}; do
              [[ $_host == $i ]] && continue 2
            done
            set -s -A HOST_LIST ${HOST_LIST[*]} $_host
          done
        done <$_file
}

[[ -s /etc/ssh/ssh_known_hosts ]] && read_known_hosts /etc/ssh/ssh_known_hosts
[[ -s ~/.ssh/known_hosts ]] && read_known_hosts ~/.ssh/known_hosts

set -A complete_ssh -- ${HOST_LIST[*]}
set -A complete_scp -- ${HOST_LIST[*]}
set -A complete_mosh -- ${HOST_LIST[*]}

function prompt_dir {
        echo "$(pwd)" | sed -e "s,^$HOME,~,g"
}

export PS1='\e[1;32m\w \e[1;34m$(git_status)\n\e[m-> '

