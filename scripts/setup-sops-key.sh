#!/bin/bash

# SOPS Age Private Key (dotfiles)を1Passwordから取得
if command -v op &> /dev/null; then
    if op account list &> /dev/null; then
        export SOPS_AGE_KEY=$(op item get "SOPS Age Private Key (dotfiles)" --field 'age_private_key') 2>/dev/null
    else
        echo "1Password CLI not signed in" >&2
        exit 1
    fi
else
    echo "1Password CLI not found" >&2
    exit 1
fi
