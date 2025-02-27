#!/usr/bin/env bash

HOST="${1:-$HOST}"

attr="$FLAKEROOT#$HOST"
if [ -x /run/wrappers/bin/sudo ]; then
    export PATH=/run/wrappers/bin:$PATH
    sudo nixos-rebuild --flake "$attr" "${@:2}"
else
    nixos-rebuild --flake "$attr" "${@:2}"
fi
