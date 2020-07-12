#!/usr/bin/env bash
source helpers.sh

######################################################################
# Formulae and casks
######################################################################
formulae=(cask wget python3 shfmt p7zip mas dockutil kubectl gradle rabbitmq)
common_casks=(1password 1password-cli spotify tidal vivaldi iterm2 docker postman visual-studio-code homebrew/cask-fonts/font-fira-code flux slack gimp telegram 1password-cli 1password)
personal_casks=(malwarebytes avast-security veracrypt steam discord)

######################################################################
# Homebrew
######################################################################
inform "Installing homebrew formulae"
pour_formulae "${formulae[@]}"

inform "Installing casks"
echo ${common_casks[@]}
tap_casks "${common_casks[@]}"

if [[ $PERSONAL == y ]]; then
    echo ${personal_casks[@]}
    inform "Installing personal applications"
    tap_casks "${personal_casks[@]}"
fi
