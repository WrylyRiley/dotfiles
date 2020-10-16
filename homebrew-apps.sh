#!/usr/bin/env bash
. helpers.sh
# Formulae and casks
formulae=(
    cask
    dockutil
    kubectl
    mas
    p7zip
    python3
    redis
    shfmt
    thefuck
    wget
    xcv
)
common_casks=(
    1password
    1password-cli
    docker
    flux
    gimp
    homebrew/cask-fonts/font-fira-code
    homebrew/cask-versions/firefox-developer-edition
    insomnia
    iterm2
    slack
    telegram-desktop
    tidal
    visual-studio-code
)
personal_casks=(
    veracrypt
    steam
    discord
)
# Homebrew
inform "Installing formulae"
pour_formulae "${formulae[@]}"
inform "Installing casks"
tap_casks "${common_casks[@]}"
[[ $PERSONAL == y ]] && inform "Installing personal casks" && tap_casks "${personal_casks[@]}"
