#!/usr/bin/env bash

######################################################################
# Helper Functions
######################################################################
error() {
    printf "\x1b[1;31m\n$1\x1b[0m\n"
}
warn() {
    printf "\x1b[1;34m\n$1\x1b[0m\n"
}
inform() {
    printf "\x1b[1;32m\n$1\x1b[0m\n"
}

brew_update() {
    if [[ $UPDATE == y ]]; then
        inform "Updating all formulae"
        brew upgrade
        inform "Updating all installed casks"
        brew cask upgrade
    fi
}

tap_casks() {
    local arr=("$@")
    for i in "${arr[@]}"; do
        if brew cask ls --versions "$i" >/dev/null; then
            if [[ $UPDATE == n ]]; then
                warn "Cask "$i" already installed, skipping..."
            fi
        else
            brew cask install "$i"
        fi
    done
}

pour_formulae() {
    local arr=("$@")
    for i in "${arr[@]}"; do
        if brew ls --versions "$i" >/dev/null; then
            if [[ $UPDATE == n ]]; then
                warn "Formula "$i" already installed, skipping..."
            fi
        else
            brew install "$i"
        fi
    done
}

install_homebrew() {
    if which brew >/dev/null; then
        if [[ $UPDATE == y ]]; then
            inform "Homebrew already installed, updating..."
            brew update
        fi
        inform "Homebrew already installed, skipping update..."
    else
        inform "Installing homebrew"
        /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    fi
}
