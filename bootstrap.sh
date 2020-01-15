#!/bin/bash

######################################################################
# Collections
######################################################################
formulae=(cask wget python@3 node lastpass-cli shfmt p7zip mas dockutil)
common_casks=(spotify tidal vivaldi brave-browser iterm2 docker postman visual-studio-code homebrew/cask-fonts/font-fira-code flux slack gimp caffeine)
personal_casks=(google-backup-and-sync malwarebytes avast-security telegram veracrypt steam discord)
# Magnet, Amphetamine, Giphy, Speedtest by Ookla, Pages
mac_store_apps=(937984704 441258766 668208984 1153157709 409201541)
PERSONAL=n
UPDATE=n
LPKEYS=n
MACSTORE=n
CHANGEDOCK=n
DEFAULTS=n

######################################################################
# Helper Functions
######################################################################

# printf in bold cyan
inform() { printf "\x1b[1;96m\n$1\x1b[0m"; }

brew_update() {
	if [[ $UPDATE == y ]]; then
		inform "Updating all formulae"
		brew upgrade
		inform "Updating all instlaled casks"
		brew cask upgrade
	fi
}

tap_casks() {
	# destructure array into all refs
	local arr=("$@")
	for i in "${arr[@]}"; do
		if brew cask ls --versions "$i" >/dev/null; then
			if [[ $UPDATE == n ]]; then
				inform "Cask "$i" already installed, skipping..."
			fi
		else
			brew cask install "$i"
		fi
	done
}

pour_formulae() {
	# destructure array into all refs
	local arr=("$@")
	for i in "${arr[@]}"; do
		if brew ls --versions "$i" >/dev/null; then
			if [[ $UPDATE == n ]]; then
				inform "Formula "$i" already installed, skipping..."
			fi
		else
			brew install "$i"
		fi
	done
}

######################################################################
# Install Homebrew and Whiptail
######################################################################
inform "Installing homebrew and whiptail"
if which brew >/dev/null; then
	if [[ $UPDATE == y ]]; then
		inform "Homebrew already installed, updating..."
		brew update
	fi
	inform "Homebrew already installed, skipping update..."
else
	/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Install whiptail for UI
pour_formulae newt

######################################################################
# Initialization dialog - https://ubuntuforums.org/showthread.php?t=2099509
######################################################################

if (whiptail --title "Riley's Bootstrap Script" --yesno "Is this an installation?" 12 78); then

	# Password request
	PASSWORD=$(whiptail --passwordbox "Please enter your system password" 8 78 --title "password dialog" 3>&1 1>&2 2>&3)
	# Exit check
	exitstatus=$?
	if [ ! $exitstatus = 0 ]; then exit 0; fi

	# Elevate and keep-alive
	sudo -v -S $PASSWORD
	while true; do
		sudo -n true
		sleep 60
		kill -0 "$$" || exit
	done 2>/dev/null &

	# Modifiers
	whiptail --title "Modifiers" --checklist --separate-output \
		"Select installation modifiers" 22 78 8 \
		"PERSONAL" "Personal Computer" OFF \
		"UPDATE" "Update Homebrew casks & formulae, and global npm modules" ON \
		"LPKEYS" "Download RSA keys from lastpass" OFF \
		"MACSTORE" "Download Mac store apps" OFF \
		"CHANGEDOCK" "Change dock icons" OFF \
		"GIT" "Update git user name and email?" OFF \
		"DEFAULTS" "Change system preferences" OFF 2>modifiers

	# Exit check
	exitstatus=$?
	if [ ! $exitstatus = 0 ]; then exit 0; fi

	while read choice; do
		case $choice in
		"PERSONAL") PERSONAL=y ;;
		"UPDATE") UPDATE=y ;;
		"LPKEYS") LPKEYS=y ;;
		"MACSTORE") MACSTORE=y ;;
		"CHANGEDOCK") CHANGEDOCK=y ;;
		"GIT") GIT=y ;;
		"DEFAULTS") DEFAULTS=y ;;
		esac
	done <modifiers
	rm ./modifiers

	######################################################################
	# Terminal developer tools
	######################################################################
	inform "Installing xcode developer tools"
	if which xcode-select >/dev/null; then
		inform "xcode tools already installed, skipping..."
	else
		xcode-select --install
	fi

	######################################################################
	# Install homebrew formulae and casks
	######################################################################

	inform "Installing homebrew formulae"
	pour_formulae $formulae

	inform "Installing casks"
	tap_casks $common_casks

	if [[ $PERSONAL == y ]]; then
		inform "Installing personal applications"
		tap_casks $personal_casks
	fi

	######################################################################
	# Request personal rsa keys for ssh access to github
	# This will be necessary for the script to pull from secret gists
	######################################################################
	if [[ $LPKEYS == y ]]; then
		source "./scripts/rsa.sh"
		# Set flag for Lastpass signin
		LPSIGNIN=1
	else
		inform "No RSA keys will be entered or changed"
	fi

	######################################################################
	# Mac store apps
	######################################################################
	if [[ $MACSTORE == y ]]; then
		if (whiptail --title "Mac App Store" --yesno "Would you like to use LastPass to copy your password?" 11 78); then
			lpass login --trust zbauer91@gmail.com
			lpass show -c --password Apple
		fi
		whiptail --msgbox --title "Mac App Store" "Please sign into the app store before continuing..." 11 78
		for i in "${mac_store_apps[@]}"; do
			mas install "$i"
		done
	else
		inform "No Mac store apps will be installed"
	fi

	######################################################################
	# iTerm2 Preferences
	######################################################################
	inform "Configuring iTerm2"
	iterm_plist=$HOME/Library/Application\ Support/iTerm2/DynamicProfiles/profiles.plist
	cp "./config/itermProfiles.json" $iterm_plist
	inform "Make sure you change your default profile in iTerm"

	######################################################################
	# oh-my-zsh
	######################################################################
	inform "Installing oh-my-zsh"
	[! -d "$HOME/.oh-my-zsh"] && sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sed '/\s*env\s\s*zsh\s*/d')"
	curl -L -o ~/.oh-my-zsh/themes/bullet-train.zsh-theme http://raw.github.com/caiogondim/bullet-train-oh-my-zsh-theme/master/bullet-train.zsh-theme

	######################################################################
	# zsh settings
	######################################################################
	inform "Backing up zshrc to ~/.zshrc.bak"
	cp $HOME/.zshrc $HOME/.zshrc.bak
	cp "./config/.zshrc" $HOME/.zshrc

	######################################################################
	# Change default shell to zsh
	######################################################################
	SH=$(echo $SHELL)
	if [[ $SH == /bin/zsh ]]; then
		inform "zsh is already the default shell"
	else
		inform "Changing default shell to zsh"
		chsh -s $(grep /zsh$ /etc/shells | tail -1)
	fi
	source $HOME/.zshrc

	######################################################################
	# Miscellaneous config files
	######################################################################
	cp "./config/.hushlogin" "$HOME/.hushlogin"

	######################################################################
	# Git Settings
	######################################################################

	if [[ $GIT == y ]]; then
		git config --global user.name "Riley Bauer"
		if [[ $PERSONAL == y ]]; then
			inform "Using personal email in git"
			git config --global user.email "zbauer91@gmail.com"
		else
			inform "Using Upside email in Git"
			git config --global user.email "riley@upside.com"
		fi
	fi

	######################################################################
	# Global Node Modules
	######################################################################
	inform "Installing global node modules"
	if [[ $UPDATE == y ]]; then
		npm update -g @vue/cli @angular/cli create-react-app fkill nodemon typescript lerna
		npm i -g npm
	else
		npm i -g @vue/cli @angular/cli create-react-app fkill nodemon typescript lerna
	fi

	######################################################################
	# Add programming folder
	######################################################################
	PROG=$HOME/programming
	if [[ -d PROG ]]; then
		inform "Programming director already exists at $PROG"
	else
		inform "Creating programming directory at $PROG"
		mkdir $HOME/programming
	fi

	######################################################################
	# Adding only the shortcuts I want to the dock
	######################################################################
	if [[ $CHANGEDOCK == y ]]; then
		inform "Modifying Dock"
		source './scripts/dock-settings.sh'
	else
		inform "Not Modifying Dock"
	fi
	######################################################################
	# Apple configuration
	######################################################################

	if [[ $DEFAULTS == y ]]; then
		inform "Setting a handful of defaults settings"
		source "./scripts/mac-defaults.sh"
	fi

	######################################################################
	# Wallpaper
	######################################################################
	inform "Downloading most recent desktop wallpaper"
	curl -o $HOME/desktop.jpg http://rileyrabbit.com/desktop.jpg

	######################################################################
	# Finish
	######################################################################
	brew_update
	whiptail --msgbox --title "Bootstrap Complete" "You're done! Congratulations! You'll need to sign out to see some changesß take effect. Please do that now :) " 11 78

else
	if (whiptail --title "Uninstall bootstrapped applications" --yesno "Are you absolutely certain you want to unbootstrap your environment?" 8 78); then

		######################################################################
		# Uninstall Everything
		######################################################################

		# Clear dock
		dockutil remove --all

		# Apple store apps
		rm -rf /Appplications/Magnet.app
		rm -rf /Appplications/Amphetamine.app
		rm -rf /Appplications/Giphy.app
		rm -rf "/Appplications/Speedtest by Ookla.app"

		# Homebrew formulae and casks
		brew uninstall $pour_formulae
		brew cask uninstall $common_casks
		brew cask uninstall $personal_casks

		# npm modules
		npm ls -gp --depth=0 | awk -F/ '/node_modules/ && !/\/npm$/ {print $NF}' | xargs npm -g rm

		# User data
		sudo rm -rf /Users/rileybauer/Library/Application Support/Vivaldi
		sudo rm -rf /Users/rileybauer/Library/Application Support/iTerm2
		sudo rm -rf /Users/rileybauer/Library/Application Support/Spotify
		sudo rm -rf /Users/rileybauer/Library/Application Support/GIMP
		sudo rm -rf /Users/rileybauer/Library/Application Support/BraveSoftware
		sudo rm -rf /Users/rileybauer/Library/Application Support/Postman
	else
		exit 0
	fi
	exit 0
fi
exit 0
