#!/usr/bin/env bash
. helpers.sh

######################################################################
# Formulae and casks
######################################################################
formulae=(
    cask
    dockutil
    gradle
    kubectl
    mas
    p7zip
    python3
    rabbitmq
    shfmt
    wget
)
common_casks=(
    1password
    1password-cli
    docker
    flux
    gimp
    homebrew/cask-fonts/font-fira-code
    homebrew/cask-versions/firefox-developer-edition
    iterm2
    postman
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

######################################################################
# Homebrew
######################################################################

inform "Installing formulae"
pour_formulae "${formulae[@]}"

inform "Installing casks"
tap_casks "${common_casks[@]}"

[[ $PERSONAL == y ]] && inform "Installing personal casks" && tap_casks "${personal_casks[@]}"
