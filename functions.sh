function git_status {
	branch=$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/')
	if [ ! "${branch}" = "" ]
	then
		git_changed="$(parse_git_changed)"
		echo "${branch}${git_changed}"
	else
		echo ""
	fi
}

function parse_git_changed {
        git_status_result=$(git status 2>&1)
        if [ $(echo "$git_status_result" | grep -c "nothing to commit, working tree clean") -eq 0  ] 
        then
                echo "*"
        else
                echo ""
         fi

}

