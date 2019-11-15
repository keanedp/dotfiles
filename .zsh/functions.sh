function git_status() {
	branch=$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/')
	if [ ! "${branch}" = "" ]
	then
		stat=`parse_git_dirty`
		echo "[${branch}${stat}]"
	else
		echo ""
	fi
}

function parse_git_dirty() {
        git_status=$(git status 2>&1 | tee)
	dirty=$(echo -n "${git_status}" 2> /dev/null | grep "modified:" &> /dev/null; echo "$?")
	untracked=$(echo -n "${git_status}" 2> /dev/null | grep "Untracked files" &> /dev/null; echo "$?")
	ahead=$(echo -n "${git_status}" 2> /dev/null | grep "Your branch is ahead of" &> /dev/null; echo "$?")
	newfile=$(echo -n "${git_status}" 2> /dev/null | grep "new file:" &> /dev/null; echo "$?")
	renamed=$(echo -n "${git_status}" 2> /dev/null | grep "renamed:" &> /dev/null; echo "$?")
	deleted=$(echo -n "${git_status}" 2> /dev/null | grep "deleted:" &> /dev/null; echo "$?")
	bits=''
	if [ "${renamed}" = "0" ]; then
		bits=">${bits}"
	fi
	if [ "${ahead}" = "0" ]; then
		bits="*${bits}"
	fi
	if [ "${newfile}" = "0" ]; then
		bits="+${bits}"
	fi
	if [ "${untracked}" = "0" ]; then
		bits="?${bits}"
	fi
	if [ "${deleted}" = "0" ]; then
		bits="-${bits}"
	fi
	if [ "${dirty}" = "0" ]; then
		bits="!${bits}"
	fi
	if [ ! "${bits}" = "" ]; then
		echo " ${bits}"
	else
		echo ""
	fi
}

