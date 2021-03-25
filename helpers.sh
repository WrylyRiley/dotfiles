#!/usr/bin/env bash
# Terminal colors
C="\033[1;32m"
R="\033[0m"
# Helper Functions
warn() { printf "\x1b[1;34m\n$1\x1b[0m"; }
error() { printf "\x1b[1;31m\n$1\x1b[0m"; }
inform() { printf "\x1b[1;32m\n$1\x1b[0m"; }
readColor() { return "\033[1;32m\n$1\033[0m"; }
tap_casks() { arr=("$@") && for i in "${arr[@]}"; do { brew ls --cask --versions $i >/dev/null && warn "$i already brewed..."; } || brew install --cask $i; done; }
pour_formulae() { arr=("$@") && for i in "${arr[@]}"; do { brew ls --versions $i >/dev/null && warn "$i already brewed..."; } || brew install $i; done; }
install_homebrew() {
    { which brew >/dev/null && error "Homebrew already installed..."; } || {
        inform "Installing homebrew"
        echo | /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
        if [ $? -eq 0 ]; then inform 'Install successful'; else error "Install failed"; fi
    }
}
