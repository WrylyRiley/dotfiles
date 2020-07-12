#!/usr/bin/env bash

######################################################################
# Initialization
######################################################################
. global-vars.sh
. helpers.sh

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
read -n 1 RSA
inform "Update git user name and email?  y/n"
read -n 1 GIT
inform "Change system preferences?  y/n"
read -n 1 DEFAULTS
if [[ ! -d $HOME/programming ]]; then
	mkdir $HOME/programming
fi

######################################################################
# Install Homebrew
######################################################################
install_homebrew

######################################################################
# Terminal developer tools
######################################################################
if which xcode-select >/dev/null; then
	inform "xcode developer tools already installed, skipping..."
else
	inform "Installing xcode developer tools"
	xcode-select --install
fi

######################################################################
# Install homebrew formulae and casks
######################################################################
if [[ $HOMEBREW == y ]]; then
	sh ./homebrew.sh
else
	inform "No changes made to homebrew"
fi

######################################################################
# RSA Keys - 1Password
######################################################################
if [[ $RSA == y ]]; then
	sh ./rsa.sh
else
	inform "Not installing RSA keys"
fi

######################################################################
# Mac store apps
######################################################################
if [[ $MACSTORE == y ]]; then
	# Magnet, Amphetamine, Giphy, Speedtest by Ookla, Pages, XCode
	mac_store_apps=(937984704 441258766 668208984 1153157709 409201541 497799835)
	warn "Please sign into the Mac store before continuing"
	read -n 1 -r -s CON
	for i in "${mac_store_apps[@]}"; do
		mas install "$i"
	done
else
	inform "No Mac store apps will be installed"
fi

######################################################################
# iTerm2 Preferences
######################################################################
if [[ $ITERM == y ]]; then
	inform "Updating iTerm preferences"
	sh ./iterm.sh
else
	inform "Not updating iTerm preferences"
fi

######################################################################
# Git Settings
######################################################################
if [[ $GIT == y ]]; then
	inform "Updating git settings"
	sh ./git-settings.sh
else
	inform "Not updating git settings"
fi
######################################################################
# Adding only the shortcuts I want to the dock
######################################################################
if [[ $CHANGEDOCK == y ]]; then
	inform "Modifying Ddck"
	sh ./dock-settings.sh
else
	inform "Not modifying dock"
fi
######################################################################
# Apple configuration
######################################################################

if [[ $DEFAULTS == y ]]; then
	inform "Setting Mac preferences"
	sh ./mac-defaults.sh
else
	inform "Not changing system preferences"
fi

######################################################################
# oh-my-zsh
######################################################################
sh ./zshell.sh

######################################################################
# Global Node Modules
######################################################################
if [[ $NODEMOD == y ]]; then
	sh ./nvm.sh
else
	inform "Not installing global node modules"
fi

######################################################################
# Finish
######################################################################
cp "./config/.hushlogin" "$HOME/.hushlogin"
sh ./cleanup.sh
inform "You're done! Congratulations! You'll need to sign out to see some changes take effect. Please do that now :)"
exit 0
