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
# Initialize
######################################################################
sudo -v

# Keep-alive: update existing sudo time stamp until bootstrap has finished
while true; do
	sudo -n true
	sleep 60
	kill -0 "$$" || exit
done 2>/dev/null &

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

if (whiptail --title "Riley's Bootstrap Script" --yesno "Is this an installation?" 11 78); then

	whiptail --title "Modifiers" --checklist --separate-output \
		"Select installation modifiers" 22 78 6 \
		"PERSONAL" "Personal Computer" OFF \
		"UPDATE" "Update Homebrew casks & formulae, and global npm modules" ON \
		"LPKEYS" "Download RSA keys from lastpass" OFF \
		"MACSTORE" "Download Mac store apps" OFF \
		"CHANGEDOCK" "Change dock icons" OFF \
		"GIT" "Update git user name and email?" OFF \
		"DEFAULTS" "Change system preferences" OFF 2>results

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
	done <results

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
		# Add folders and files
		mkdir $HOME/.ssh
		touch $HOME/.ssh/personal.pub
		touch $HOME/.ssh/personal
		# Start ssh agent
		eval "$(ssh-agent -s)"
		# Get keys
		lpass login --trust zbauer91@gmail.com # Sign in to LastPass CLI
		inform "Retrieving public key"
		lpass show -c --field="Public Key" personal_rsa_key
		pbpaste >$HOME/.ssh/personal.pub
		inform "Retrieving private key"
		lpass show -c --field="Private Key" personal_rsa_key
		pbpaste >$HOME/.ssh/personal
		# Set permissions
		chmod 400 $HOME/.ssh/personal.pub $HOME/.ssh/personal
		# Set config for Sierra+
		echo "Host *
    AddKeysToAgent yes
    UseKeychain yes
    IdentityFile ~/.ssh/personal" >$HOME/.ssh/config
		# Add new key to ssh agent
		ssh-add -K $HOME/.ssh/personal
		# Set flag for Lastpass signin
		$LPSIGNIN=1
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
	cp "./itermProfiles.json" $iterm_plist
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
	cp "./.zshrc" $HOME/.zshrc

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
	cp "./.hushlogin" "$HOME/.hushlogin"

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
		dockutil --remove all
		dockutil --add '~/Downloads'
		dockutil --add '~/programming'
		dockutil --add '/Applications/Vivaldi.app'
		dockutil --add '/Applications/Brave Browser.app'
		dockutil --add '/Applications/iTerm.app'
		dockutil --add '/Applications/Slack.app'
		dockutil --add '/Applications/Spotify.app'
		dockutil --add '/Applications/TIDAL.app'
		dockutil --add '/Applications/Postman.app'
		dockutil --add '/Applications/Visual Studio Code.app'
		dockutil --add '/System/Applications/System Preferences.app'
		if [[ $PERSONAL == y ]]; then
			inform " Adding personal shortcuts"
			dockutil --add '/Applications/Telegram.app'
			dockutil --add '/Applications/Steam.app'
		fi
	else
		inform "Not Modifying Dock"
	fi
	######################################################################
	# Apple configuration
	######################################################################
	#Shamelessly stolen from https://github.com/mathiasbynens/dotfiles

	if [[ $DEFAULTS == y ]]; then
		inform "Setting a handful of defaults settings"

		# Close any open System Preferences panes, to prevent them from overriding
		# settings we’re about to change
		osascript -e 'tell application "System Preferences" to quit'

		# Set highlight color to purple
		defaults write NSGlobalDomain AppleHighlightColor -string "0.968627 0.831373 1.000000"

		# Set system-wide dark mode
		defaults write NSGlobalDomain AppleInterfaceStyle -string "Dark"

		# Set sidebar icon size to medium
		defaults write NSGlobalDomain NSTableViewDefaultSizeMode -int 2

		# Show all extensions
		defaults write NSGlobalDomain AppleShowAllExtensions -int 1

		# Disable automatic capitalization as it’s annoying when typing code
		defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

		# Disable smart dashes as they’re annoying when typing code
		defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

		# Disable automatic period substitution as it’s annoying when typing code
		defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false

		# Disable smart quotes as they’re annoying when typing code
		defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

		# Disable press-and-hold for keys in favor of key repeat
		defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

		# Set a blazingly fast keyboard repeat rate
		defaults write NSGlobalDomain InitialKeyRepeat -int 15
		defaults write NSGlobalDomain KeyRepeat -int 4

		# Disable Notification Center and remove the menu bar icon
		# launchctl unload -w /System/Library/LaunchAgents/com.apple.notificationcenterui.plist 2>/dev/null

		# Set a custom wallpaper image. `DefaultDesktop.jpg` is already a symlink, and
		# all wallpapers are in `/Library/Desktop Pictures/`. The default is `Wave.jpg`.
		#curl -o $HOME/desktop.jpg http://rileyrabbit.com/desktop.jpg
		#sqlite3 $HOME/Library/Application\ Support/Dock/desktoppicture.db <<EOF
		#UPDATE data SET value = "$HOME/desktop.jpg";
		#.quit
		#EOF

		# Require password immediately after sleep or screen saver begins
		# defaults write com.apple.screensaver askForPassword -int 1
		# defaults write com.apple.screensaver askForPasswordDelay -int 0

		# Show icons for hard drives, servers, and removable media on the desktop
		defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
		defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true
		defaults write com.apple.finder ShowMountedServersOnDesktop -bool true
		defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true

		# Finder: show hidden files by default
		defaults write com.apple.finder AppleShowAllFiles -bool true

		# Finder: show all filename extensions
		defaults write NSGlobalDomain AppleShowAllExtensions -bool true

		# Finder: show status bar
		defaults write com.apple.finder ShowStatusBar -bool true

		# Finder: show path bar
		defaults write com.apple.finder ShowPathbar -bool true

		# Display full POSIX path as Finder window title
		defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

		# Keep folders on top when sorting by name
		defaults write com.apple.finder _FXSortFoldersFirst -bool true

		# Disable the warning when changing a file extension
		defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

		# Use list view in all Finder windows by default
		# Four-letter codes for the other view modes: `icnv`, `clmv`, `glyv`
		defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

		# Show the ~/Library folder
		chflags nohidden ~/Library

		# Show the /Volumes folder
		# sudo chflags nohidden /Volumes

		# Disable Dashboard
		# defaults write com.apple.dashboard mcx-disabled -bool true

		# Automatically hide and show the Dock
		defaults write com.apple.dock autohide -bool true

		# Disable the Launchpad gesture (pinch with thumb and three fingers)
		# defaults write com.apple.dock showLaunchpadGestureEnabled -int 0

		# Set the icon size of Dock items to 54 pixels
		defaults write com.apple.dock tilesize -int 54

		# Enable the Develop menu and the Web Inspector in Safari
		defaults write com.apple.Safari IncludeDevelopMenu -bool true
		defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
		defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true

		# Enable the automatic mac store update check
		defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true

		# Download newly available updates in background
		defaults write com.apple.SoftwareUpdate AutomaticDownload -int 1

		# Kill affected applications
		for app in "Activity Monitor" \
			"cfprefsd" \
			"Dock" \
			"Finder" \
			"Safari" \
			"SystemUIServer"; do

			killall "${app}" &>/dev/null
		done

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
