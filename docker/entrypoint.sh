#!/bin/bash

set -o errexit

die() {
	printf "Usage: %s: WORKDIR SCRIPT...\n" "$0"
	echo "$*" >&2
	exit 1
}

if [[ $# -eq 0 ]]; then
	echo >&2 "No working directory specified"
	die "$@"
elif [[ $# -eq 1 ]]; then
	echo >&2 "No test script specified"
	die "$@"
fi

workdir="$1"
script="$2"
shift 2

cd "$workdir"
bash "$script" "$@"
