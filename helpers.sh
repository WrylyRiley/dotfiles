#!/usr/bin/env bash

######################################################################
# Helper Functions
######################################################################
error() { printf "\x1b[1;31m\n$1\x1b[0m\n"; }
warn() { printf "\x1b[1;34m\n$1\x1b[0m\n"; }
inform() { printf "\x1b[1;32m\n$1\x1b[0m\n"; }

tap_casks() {
    local arr=("$@")
    for i in "${arr[@]}"; do { brew cask ls --versions $i >/dev/null && warn "$i already brewed..."; } || brew cask install $i; done
}

pour_formulae() {
    local arr=("$@")
    for i in "${arr[@]}"; do { brew ls --versions $i >/dev/null && warn "$i already brewed..."; } || brew install $i; done
}

install_homebrew() {
    if which brew >/dev/null; then
        error "Homebrew already installed..."
    else
        inform "Installing homebrew"
        echo | /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
        if [ $? -eq 0 ]; then inform 'Install successful'; else error "Install failed"; fi
    fi
}
