#!/bin/bash

set -o errexit

[[ -v LIVE_DEBUG ]] && set -o xtrace

help() {
	echo "$*" >&2
	exit 1
}

die() {
	printf "%s: ${LAST_ERROR}\n" "$0" >&2
	exit 1
}
live() {
	true
}
live_or_die=${LIVE_OR_DIE:-die}

LAST_ERROR=
trap '$live_or_die' ERR

gh_mode=0
# shellcheck disable=SC2153
[[ -v GH_MODE ]] && gh_mode=1

gh_echo() {
	local gh_commands

	[[ "$gh_mode" == 0 ]] && return 0;
	read -d $'\0' -r gh_commands || true;
	echo -en "${gh_commands}\n"
}

help-test() {
	printf "Usage: %s: SRCDIR..." "$0"
	help echo "$@"
}

# greetings for github runner
echo '::notice::Shellcheck action started!' | gh_echo

if [[ $# -eq 0 ]]; then
	echo >&2 "No source directories specified"
	help-test "$@"
fi

declare -a dirs
if [[ "$gh_mode" == 1 ]]; then
	readarray -t -d $'\n' dirs < <(echo -e "$@")
else
	dirs+=("$@")
fi

echo '::echo::on' | gh_echo
echo '::group::Shellcheck action' | gh_echo

# scan for `sh` files in specified directories
files=()

for src_dir in "${dirs[@]}"; do
	while IFS=$'\0' read -d $'\0' -r src_file; do
		files+=("$src_file")
	done < <(find ./"$src_dir" -name '*.sh' -print0)
done

# run shellcheck
LAST_ERROR="No shell scripts for checking are found"
[[ "${#files[@]}" != 0 ]] || $live_or_die
{
	ret=$( shellcheck -f gcc "${files[@]}" >&3
		   echo $? );
} 3>&1

echo '::endgroup::' | gh_echo
echo '::echo::off' | gh_echo

if [[ $ret != 0 ]]; then
	echo '::error::Shellcheck failed' | gh_echo
else
	echo '::notice::Shellcheck passed' | gh_echo
fi

# goodbye
echo '::notice::Shellcheck action ended!' | gh_echo

exit "$ret"
