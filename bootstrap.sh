#!/usr/bin/env bash

######################################################################
# Initialization
######################################################################
. global-vars.sh
. helpers.sh

clear
inform "Welcome to the Mac bootstrap script"

# Modifiers
inform "Is this your personal Mac?  y/n"
read -n 1 PERSONAL
inform "Install Homebrew casks & formulae?  y/n"
read -n 1 HOMEBREW
inform "Install global npm modules?  y/n"
read -n 1 NODEMOD
inform "Update (instead of install) Homebrew casks & formulae, and global npm modules?  y/n"
read -n 1 UPDATE
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
if [[ ! -d $HOME/programming ]]; then
	mkdir $HOME/programming
fi

clear

######################################################################
# Install Homebrew
######################################################################
install_homebrew

######################################################################
# Terminal developer tools
######################################################################
if which xcode-select >/dev/null; then
	error "xcode developer tools already installed"
else
	inform "Installing xcode developer tools"
	xcode-select --install
fi

######################################################################
# Install homebrew formulae and casks
######################################################################
if [[ $HOMEBREW == y && $UPDATE == n ]]; then
	inform "Installing homebrew applications"
	sh ./homebrew-apps.sh
elif [[ $UPDATE == y ]]; then
	inform "Updating homebrew applications"
	brew_update
else
	error "No changes made to homebrew"
fi

######################################################################
# RSA Keys
######################################################################
if [[ $RSA == y ]]; then
	inform "Installing RSA keys"
	sh ./rsa.sh
else
	error "Not installing RSA keys"
fi

######################################################################
# Mac store apps
######################################################################
if [[ $MACSTORE == y ]]; then
	inform "Installing Mac store apps"
	sh ./mac-apps.sh
else
	error "Not installing Mac store apps"
fi

######################################################################
# iTerm2 Preferences
######################################################################
if [[ $ITERM == y ]]; then
	inform "Updating iTerm preferences"
	sh ./iterm.sh
else
	error "Not updating iTerm preferences"
fi

######################################################################
# Git Settings
######################################################################
if [[ $GIT == y ]]; then
	inform "Updating git settings"
	sh ./git-settings.sh
else
	error "Not updating git settings"
fi
######################################################################
# Adding only the shortcuts I want to the dock
######################################################################
if [[ $CHANGEDOCK == y ]]; then
	inform "Modifying Dock"
	sh ./dock-settings.sh
else
	error "Not modifying dock"
fi
######################################################################
# Apple configuration
######################################################################
if [[ $DEFAULTS == y ]]; then
	inform "Setting Mac preferences"
	sh ./mac-defaults.sh
else
	error "Not changing system preferences"
fi

######################################################################
# Global Node Modules
######################################################################
if [[ $NODEMOD == y ]]; then
	inform "Installing nvm and global node modules"
	sh ./nvm.sh
else
	error "Not installing nvm or global node modules"
fi

######################################################################
# oh-my-zsh
######################################################################
if [[ $CHANGEDOCK == y ]]; then
	inform "Configuring zsh"
	sh ./zshell.sh
else
	error "Not configuring zsh"
fi

######################################################################
# Finish
######################################################################
cp "./config/.hushlogin" "$HOME/.hushlogin"
sh ./cleanup.sh
inform "You're done! Congratulations! You'll need to sign out to see some changes take effect. Please do that now :)"
. $HOME/.zshrc
exit 0
