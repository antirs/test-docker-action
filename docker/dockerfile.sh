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

help-dockerfile() {
	printf "Usage: %s: DOCKERFILE..." "$0"
	help "$@"
}

# check dockerfile
if [[ $# -eq 0 ]]; then
	echo >&2 "No dockerfile template specified"
	help-dockerfile "$@"
fi

# check output dockerfile
if [[ $# -eq 1 ]]; then
	echo >&2 "No output dockerfile path specified"
	help-dockerfile "$@"
fi

dockerfile=$(realpath "$1")
dockerfile_out=$(realpath "$2")

LAST_ERROR="Input and output dockerfiles are the same file"
[[ "$dockerfile" != "$dockerfile_out" ]] || $live_or_die

LAST_ERROR="No dockerfile '${dockerfile}' found"
[[ -f "$dockerfile" ]] || $live_or_die

env envsubst < "$dockerfile" > "$dockerfile_out"
