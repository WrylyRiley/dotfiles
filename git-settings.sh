#!/usr/bin/env bash
. helpers.sh

######################################################################
# Git settings
######################################################################
git config --global user.name "Riley Bauer"
if [[ $PERSONAL == y ]]; then
    inform "Using personal email in git"
    git config --global user.email "zbauer91@gmail.com"
else
    inform "Using Upside email in Git"
    git config --global user.email "riley@upside.com"
fi
