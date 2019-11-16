# requite ccat from package manager
cat_handler() {
    if [ -x "$(command -v ccat)" ]; then
	    echo "ccat"
	else
	    echo "cat"
	fi
}

alias cat=$(cat_handler)
