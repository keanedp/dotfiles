# requite ccat from package manager
cat_handler() {
    if [ -x "$(command -v ccat)" ]; then
	    echo "ccat"
	else
	    echo "cat"
	fi
}

sed_handler() {
    if [ -x "$(command -v gsed)" ]; then
	    echo "gsed"
	else
	    echo "sed"
	fi
}

alias cat=$(cat_handler)
alias sed=$(sed_handler)
