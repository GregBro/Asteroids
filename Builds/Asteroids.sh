#!/bin/sh
echo -ne '\033c\033]0;Asteroids\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/Asteroids.x86_64" "$@"
