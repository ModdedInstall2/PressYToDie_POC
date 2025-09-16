#!/bin/sh
printf '\033c\033]0;%s\a' DeadmanDEMO
base_path="$(dirname "$(realpath "$0")")"
"$base_path/DeadmanDEMO_0-0-2_lnx.x86_64" "$@"
