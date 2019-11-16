function git_status() {
	branch=$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/')
	if [ ! "${branch}" = "" ]
	then
		git_changed=`parse_git_changed`
		echo "[${branch}${git_changed}]"
	else
		echo ""
	fi
}

function parse_git_changed() {
    git_status=$(git status 2>&1 | tee)
    dirty=$(echo -n "${git_status}" 2> /dev/null | grep "nothing to commit, working tree clean" &> /dev/null; echo "$?")

    if [ "${dirty}" = "1" ]; then
        echo "*"
    else
        echo ""
    fi
}
