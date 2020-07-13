#!/usr/bin/env bash

######################################################################
# Initialization
######################################################################
. global-vars.sh
. helpers.sh

clear
UPDATEinform "Welcome to the Mac bootstrap script"
# Modifiers
inform "Is this your personal Mac?  y/n"
read -n 1 PERSONAL
inform "Install Homebrew casks & formulae?  y/n"
read -n 1 HOMEBREW
inform "Install global npm modules?  y/n"
read -n 1 NODEMOD
inform "Download Mac store apps?  y/n"
read -n 1 MACSTORE
inform "Change dock icons?  y/n"
read -n 1 CHANGEDOCK
inform "Update iTerm preferences?  y/n"
read -n 1 ITERM
inform "Install RSA keys?  y/n"
read -n 1 ZSHELL
inform "Configure zsh?  y/n"
read -n 1 RSA
inform "Update git user name and email?  y/n"
read -n 1 GIT
inform "Change system preferences?  y/n"
read -n 1 DEFAULTS
[[ ! -d $HOME/programming ]] && mkdir $HOME/programming
clear

# Terminal developer tools
{ which xcode-select >/dev/null && error "xcode developer tools already installed"; } || { inform "Installing xcode developer tools" && xcode-select --install; }

# Install Homebrew
install_homebrew

# Install homebrew formulae and casks
{ [[ $HOMEBREW == y ]] && inform "Installing homebrew applications" && sh ./homebrew-apps.sh; } || error "No changes made to homebrew"

# RSA Keys
{ [[ $RSA == y ]] && inform && "Installing RSA keys" && sh ./rsa.sh; } || error "Not installing RSA keys"

# Mac store apps
{ [[ $MACSTORE == y ]] && inform && "Installing Mac store apps" && sh ./mac-apps.sh; } || error "Not installing Mac store apps"

# iTerm2 Preferences
{ [[ $ITERM == y ]] && inform && "Updating iTerm preferences" && sh ./iterm.sh; } || error "Not updating iTerm preferences"

# Git Settings
{ [[ $GIT == y ]] && inform && "Updating git settings" && sh ./git-settings.sh; } || error "Not updating git settings"

# Adding only the shortcuts I want to the dock
{ [[ $CHANGEDOCK == y ]] && inform && "Modifying Dock" && sh ./dock-settings.sh; } || error "Not modifying dock"

# Apple configuration
{ [[ $DEFAULTS == y ]] && inform && "Setting Mac preferences" && sh ./mac-defaults.sh; } || error "Not changing system preferences"

# Global Node Modules
{ [[ $NODEMOD == y ]] && inform && "Installing nvm and global node modules" && sh ./nvm.sh; } || error "Not installing nvm or global node modules"

# oh-my-zsh
{ [[ $CHANGEDOCK == y ]] && inform && "Configuring zsh" && sh ./zshell.sh; } || error "Not configuring zsh"

# Finish
cp "./config/.hushlogin" "$HOME/.hushlogin"
sh ./cleanup.sh
inform "You're done! Congratulations! You'll need to sign out to see some changes take effect. Please do that now :)"
. $HOME/.zshrc
exit 0
