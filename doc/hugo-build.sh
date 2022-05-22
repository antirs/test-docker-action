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

LAST_ERROR="git config failed"
git_config_backup="$(touch ~/.gitconfig; cat ~/.gitconfig)"

quit-git() {
	cat <<< "$git_config_backup" > ~/.gitconfig
}

trap 'quit-git' EXIT

back() {
	while popd; do :; done 2> /dev/null
	return 0
}

trap 'back' EXIT

gh_mode=0
# shellcheck disable=SC2153
[[ -v GH_MODE ]] && gh_mode=1

gh_echo() {
	local gh_commands

	[[ "$gh_mode" == 0 ]] && return 0;
	read -d $'\0' -r gh_commands || true;
	echo -en "${gh_commands}\n"
}

help-hugo-build() {
	printf "Usage: %s: DOCDIR\n" "$0"
	help "$@"
}

# check parameters
if [[ $# -eq 0 ]]; then
	echo >&2 "No working directory specified"
	help-hugo-build "$@"
fi

# check working directory
work_dir=$(realpath "$1")

LAST_ERROR="working directory is invalid"
[[ -d "$work_dir" ]] || $live_or_die

HUGO_REPO="https://github.com/gohugoio/hugo"
HUGO_PATH="$work_dir"/hugo
HUGO_BIN="$HUGO_PATH"/hugo

export GOPATH="$HUGO_PATH"/.go
export GOCACHE="$HUGO_PATH"/.cache

# clone hugo repo
pushd "$work_dir" || $live_or_die
LAST_ERROR="hugo repository clone failed"
git clone --depth=1 "${HUGO_REPO}" "$HUGO_PATH" || $live_or_die
LAST_ERROR="hugo repository safe.directory configuration failed"
# fixes go build with -buildvcs option in unsafe git directories
git config --global --add safe.directory "$HUGO_PATH" || $live_or_die
popd

# build hugo
LAST_ERROR="change directory to ${HUGO_PATH} failed"
pushd "$HUGO_PATH" || $live_or_die
LAST_ERROR="hugo build failed"
go build -ldflags "-s -w" || $live_or_die
echo "::set-output name=hugo_bin::""$HUGO_BIN" | gh_echo
popd
