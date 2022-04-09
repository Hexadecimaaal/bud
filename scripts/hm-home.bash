#!/usr/bin/env bash
if [[ "$1" == "switch" ]]; then
    shift 1
    switch=y
fi

portable=

if [[ "$1" == *"@"* ]]; then
    HMUSER="$(cut -d '@' -f 1 <<<"$1")"
    HOST="$(cut -d '@' -f 2 <<<"$1")"

    # only user provided, intend to deploy the portable version
elif [[ ! -z "$1" ]] && [[ -z "$2" ]]; then
    portable=y
    HMUSER="${1}"

    # nothing or both provided
else
    HMUSER="${1:-$USER}"
    HOST="${2:-$HOST}"
    HOST="$(
        IFS='.'
        parts=($(echo $HOST))
        IFS=' '
        host=$(for ((idx = ${#parts[@]} - 1; idx >= 0; idx--)); do printf \"\${parts[idx]}.\"; done)
        echo \${host:: -1}
    )"
fi

hostattr="$FLAKEROOT#homeConfigurations.\"$HMUSER@$HOST\".activationPackage"
portableattr="$FLAKEROOT#homeConfigurationsPortable.$ARCH.\"$HMUSER\".activationPackage"

if [[ "$portable" == "y" ]]; then
    attr="$portableattr"
else
    attr="$hostattr"
fi

if [[ "$switch" == "y" ]]; then
    nix build "$attr" "${@:3}" && result/activate && unlink result
else
    nix build "$attr" "${@:3}"
fi
