#!/usr/bin/env bash
. helpers.sh
# Git settings
git config --global user.name "Riley Bauer"
git config --global user.email $([[ $PERSONAL == y ]] && echo "zbauer91@gmail.com" || echo "riley@upside.com")
inform "Using $([[ $PERSONAL == y ]] && echo "personal" || echo "work") email in git"
