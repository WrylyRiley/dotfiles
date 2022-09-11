#!/bin/zsh

##################################
####   Helper Functions          #
##################################
warn() { printf "\x1b[1;34m🟡 $1\x1b[0m\n"; }
error() { printf "\x1b[1;31m🔴 $1\x1b[0m\n"; }
inform() { printf "\x1b[1;32m🟢 $1\x1b[0m\n"; }
ARM = n
if [[ $(arch) == 'arm64' ]]; then
  $ARM = y
fi

##################################
# Terminal developer tools       #
##################################
{ which xcode-select &>/dev/null && error "xcode developer tools already installed"; } || {
  inform "Installing xcode developer tools"
  sudo xcode-select --install
  inform "Enabling xcode-select tooling"
  sudo xcode-select -s /Applications/Xcode.app/Contents/Developer
  sudo xcodebuild -license accept
}

##################################
# Homebrew                       #
##################################
{ which brew &>/dev/null && warn "Homebrew already installed..."; } || {
  inform "Installing homebrew"
  echo | NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  if [[ $ARM == y ]]; then
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >>$HOME/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
}

##################################
# Brew bundle                    #
##################################
warn "Please sign into the Mac store before continuing. Press return to continue"
read -n 0
inform "Running brew bundle"
brew bundle install

##################################
# SSH agent, SSH key, GPG key    #
##################################
mkdir -p $HOME/.ssh
inform "Would you like to restore your SSH key? Please ensure all files are in ~ (y/n)"
read -q KEYS
if [[ $KEYS == y ]]; then
  inform "\nAdding key to ssh-agent"
  mv ~/id_ed25519 ~/.ssh/id_ed25519
  mv ~/id_ed25519.pub ~/.ssh/id_ed25519.pub
  eval "$(ssh-agent -s)"
  touch $HOME/.ssh/config
  chmod 400 $HOME/.ssh/id_ed25519.pub $HOME/.ssh/id_ed25519
  echo "Host *
    AddKeysToAgent yes
    UseKeychain yes
    IdentityFile ~/.ssh/id_ed25519" >$HOME/.ssh/config
  [[ $ARM == y ]] && ssh-add --apple-use-keychain $HOME/.ssh/id_ed25519 || ssh-add -K $HOME/.ssh/id_ed25519
else
  warn "\nSkipping SSHkey..."
fi

inform "Would you like to restore your GPG key? Please ensure all files are in ~ (y/n)"
read -q GPG
if [[ $GPG == y ]]; then
  inform "\nImporting GPG key and Trust DB"
  gpg --import $HOME/secret-key-backup.asc
  gpg --import-ownertrust <$HOME/trustdb-backup.txt
  rm $HOME/secret-key-backup.asc
  rm $HOME/trustdb-backup.txt
else
  warn "\nSkipping GPG key..."
fi

##################################
# iTerm2 Preferences             #
##################################
plistdir=$HOME/Library/Application\ Support/iTerm2/DynamicProfiles
mkdir -p $plistdir
inform "Setting iTerm preferences"
cp -f "./itermProfiles.json" "${plistdir}/profiles.plist"
warn "Make sure you change your default profile in iTerm"
inform "Consider changing non-profile settings like preventing automatic copying on text selection, and natural typing"

##################################
# Git Preferences                #
##################################
inform "Setting git preferences"
cp ./.gitconfig $HOME/.gitconfig

##################################
# Python modules                 #
##################################
# Needed to do physical device debuging with Flipper
inform "Installing IDB client for Flipper debugging"
pip3 install fb-idb

##################################
# zsh, plugins, settings         #
##################################
export ZSHCONFIG="$HOME/.config/zsh"
mkdir -p $ZSHCONFIG

inform "Installing zsh syntax highlighting"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSHCONFIG
inform "Installing zsh autosuggestions"
git clone https://github.com/zsh-users/zsh-autosuggestions $ZSHCONFIG
inform "Installing zsh completions"
git clone https://github.com/zsh-users/zsh-completions.git $ZSHCONFIG
inform "Copying static aliases"
cp ./static_aliases.zsh $ZSHCONFIG
inform "installing your themes"
cp ./rileyb.zsh-theme $ZSHCONFIG
cp ./agnoster.zsh-theme $ZSHCONFIG

inform "Backing up ~/.zshrc to ~/.zshrc.bak"
cp $HOME/.zshrc $HOME/.zshrc.bak
inform "Copying new config"
cp ./.zshrc $HOME/.zshrc

##################################
# System settings                #
##################################
# These are confirmed to work in Big Sur

# Dock Settings
inform "Updating dock settings"
defaults write com.apple.dock autohide -int 1
defaults write com.apple.dock autohide-time-modifier -float 0.5
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock magnification -int 0
defaults write com.apple.dock mineffect -string scale
defaults write com.apple.dock minimize-to-application -int 1
defaults write com.apple.dock mru-spaces -int 0
defaults write com.apple.dock showDesktopGestureEnabled -int 1
defaults write com.apple.dock showhidden -int 1
defaults write com.apple.dock showLaunchpadGestureEnabled -int 0
defaults write com.apple.dock showMissionControlGestureEnabled -int 1
defaults write com.apple.dock show-process-indicators -int 1
defaults write com.apple.dock show-recents -int 0
defaults write com.apple.dock tilesize -int 50

# Dock shortcuts
inform "Setting dock shortcuts"
# Not on homebrew yet for some reason
curl https://github.com/kcrawford/dockutil/releases/download/3.0.2/dockutil-3.0.2.pkg ~/Downloads
sudo installer -pkg ~/Downloads/dockutil-3.0.2.pkg -target /
dockutil --remove all
for app in "Privileges" "Visual Studio Code" "iTerm" "Vivaldi" "Insomnia" "Flipper" "Beekeeper Studio" "Slack" "Discord" "Spotify" "zoom.us" "Cricut Design Space" "Telegram Desktop" "1Password" "Steam" "Android Studio" "XCode"; do
  [[ -d "/Applications/${app}.app" ]] && dockutil --add "/Applications/${app}.app" --no-restart
done
dockutil --add '~/Downloads' --view list --display folder --no-restart
dockutil --add '~/programming' --view list --display folder

# Mouse Settings
inform "Updating trackpad settings"
defaults write com.apple.AppleMultitouchTrackpad showLaunchpadGestureEnabled -int 0
defaults write com.apple.AppleMultitouchTrackpad ActuateDetents -int 1
defaults write com.apple.AppleMultitouchTrackpad Clicking -int 0
defaults write com.apple.AppleMultitouchTrackpad DragLock -int 0
defaults write com.apple.AppleMultitouchTrackpad Dragging -int 0
defaults write com.apple.AppleMultitouchTrackpad FirstClickThreshold -int 1
defaults write com.apple.AppleMultitouchTrackpad ForceSuppressed -int 0
defaults write com.apple.AppleMultitouchTrackpad SecondClickThreshold -int 1
defaults write com.apple.AppleMultitouchTrackpad TrackpadCornerSecondaryClick -int 0
defaults write com.apple.AppleMultitouchTrackpad TrackpadFiveFingerPinchGesture -int 2
defaults write com.apple.AppleMultitouchTrackpad TrackpadFourFingerHorizSwipeGesture -int 2
defaults write com.apple.AppleMultitouchTrackpad TrackpadFourFingerPinchGesture -int 2
defaults write com.apple.AppleMultitouchTrackpad TrackpadFourFingerVertSwipeGesture -int 2
defaults write com.apple.AppleMultitouchTrackpad TrackpadHandResting -int 1
defaults write com.apple.AppleMultitouchTrackpad TrackpadHorizScroll -int 1
defaults write com.apple.AppleMultitouchTrackpad TrackpadMomentumScroll -int 1
defaults write com.apple.AppleMultitouchTrackpad TrackpadPinch -int 1
defaults write com.apple.AppleMultitouchTrackpad TrackpadRightClick -int 1
defaults write com.apple.AppleMultitouchTrackpad TrackpadRotate -int 1
defaults write com.apple.AppleMultitouchTrackpad TrackpadScroll -int 1
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -int 0
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerHorizSwipeGesture -int 2
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerTapGesture -int 2
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerVertSwipeGesture -int 2
defaults write com.apple.AppleMultitouchTrackpad TrackpadTwoFingerDoubleTapGesture -int 1
defaults write com.apple.AppleMultitouchTrackpad TrackpadTwoFingerFromRightEdgeSwipeGesture -int 0
defaults write com.apple.AppleMultitouchTrackpad USBMouseStopsTrackpad -int 0
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerTapGesture -bool false

# Global Settings
inform "Updating global mac settings"
defaults write -g AppleEnableSwipeNavigateWithScrolls -int 1
defaults write -g AppleHighlightColor -string "0.968627 0.831373 1.000000"
defaults write -g AppleInterfaceStyleSwitchesAutomatically -int 1
defaults write -g ApplePressAndHoldEnabled -int 0
defaults write -g AppleScrollerPagingBehavior -int 1
defaults write -g AppleShowAllExtensions -int 1
defaults write -g CGFontRenderingFontSmoothingDisabled -int 0
defaults write -g com.apple.trackpad.scaling -int 1
defaults write -g com.apple.sound.beep.feedback -float 0
defaults write -g com.apple.swipescrolldirection -int 1
defaults write -g ContextMenuGesture -int 1
defaults write -g InitialKeyRepeat -int 15
defaults write -g KeyRepeat -int 2
defaults write -g NSAutomaticCapitalizationEnabled -int 0
defaults write -g NSAutomaticPeriodSubstitutionEnabled -int 1
defaults write -g NSNavPanelExpandedStateForSaveMode -int 1
defaults write -g NSTableViewDefaultSizeMode -int 2

# Finder Settings
inform "Updating finder settings"
defaults write com.apple.finder AppleShowAllFiles -int 1
defaults write com.apple.finder FXEnableRemoveFromICloudDriveWarning -int 0
defaults write com.apple.finder FXEnableExtensionChangeWarning -int 0
defaults write com.apple.finder FXICloudDriveDesktop -int 0
defaults write com.apple.finder FXICloudDriveDocuments -int 0
defaults write com.apple.finder FXICloudDriveEnabled -int 1
defaults write com.apple.finder FXPreferredViewStyle -string Nlsv
defaults write com.apple.finder _FXShowPosixPathInTitle -int 1
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -int 1
defaults write com.apple.finder ShowHardDrivesOnDesktop -int 1
defaults write com.apple.finder ShowPathbar -int 1
defaults write com.apple.finder ShowRemovableMediaOnDesktop -int 1
defaults write com.apple.finder ShowSidebar -int 1
defaults write com.apple.finder ShowStatusBar -int 1
defaults write com.apple.finder SidebarWidth -int 220

# Control Center Settings
inform "Updating menu bar settings"
defaults write com.apple.controlcenter "NSStatusItem Visible DoNotDisturb" -int 0
defaults write com.apple.controlcenter "NSStatusItem Visible AirDrop" -int 0
defaults write com.apple.controlcenter "NSStatusItem Visible Battery" -int 0
defaults write com.apple.controlcenter "NSStatusItem Visible Clock" -int 0
defaults write com.apple.controlcenter "NSStatusItem Visible DoNotDisturb" -int 0
defaults write com.apple.controlcenter "NSStatusItem Visible NowPlaying" -int 0
defaults write com.apple.controlcenter "NSStatusItem Visible ScreenMirroring" -int 0
defaults write com.apple.controlcenter "NSStatusItem Visible WiFi" -int 0
defaults write com.apple.Spotlight "NSStatusItem Visible Item-0" -int 0

# Show the $HOME/Library folder
inform "Unhiding ~/Library"
chflags nohidden $HOME/Library

# Enable app auto-update
inform "Enabling app store auto-updates"
defaults write com.apple.commerce AutoUpdate -int 1

# Enable subpixel antialiasing in VSCode
inform "Enabling subpixel antialiasing in VSCode"
defaults write com.microsoft.VSCode CGFontRenderingFontSmoothingDisabled -int 0

# Set a new location for screenshots
inform "Setting screnshot directory"
mkdir -p $HOME/Screen\ Shots
defaults write com.apple.screencapture location $HOME/Screen\ Shots

# create programming directory in home folder
inform "Creating ~/programming"
mkdir -p $HOME/programming

# Change the setting on the touchbar
inform "Setting touchbar preferences"
defaults write $HOME/Library/Preferences/com.apple.controlstrip MiniCustomized '(com.apple.system.screen-lock, com.apple.system.mute, com.apple.system.volume, com.apple.system.brightness )'
defaults write $HOME/Library/Preferences/com.apple.controlstrip FullCustomized '(com.apple.system.airplay, com.apple.system.group.keyboard-brightness, com.apple.system.group.brightness, com.apple.system.group.media, com.apple.system.group.volume, com.apple.system.sleep )'

# Change File Associations
inform "Setting file associations for VSCode"
duti -s com.microsoft.VSCode .sh all
duti -s com.microsoft.VSCode .css all
duti -s com.microsoft.VSCode .js all
duti -s com.microsoft.VSCode .jsx all
duti -s com.microsoft.VSCode .ts all
duti -s com.microsoft.VSCode .tsx all
duti -s com.microsoft.VSCode .xml all
duti -s com.microsoft.VSCode .yaml all
duti -s com.microsoft.VSCode .json all
duti -s com.microsoft.VSCode .md all
duti -s com.microsoft.VSCode .py all
duti -s com.microsoft.VSCode .txt all

# Karabiner configuration
inform "Configuring Karabiner"
mkdir -p $HOME/.config/Karabiner
cp ./karabiner.json $HOME/.config/karabiner

# Vivaldi configuration
# Native Messaging needs to be enabled to allow 1Password to find Vivaldi
# While chrome does this automatically, Vivaldi does not. This is the fix
inform "Enabling native messaging for Vivaldi 1Password integration"
mkdir -p $HOME/Library/Application\ Support/Google/Chrome

# Copy workspace files
cp ./truebill-native.code-workspace $HOME/programming
cp ./truebill.code-workspace $HOME/programming

# Sometimes Apple doesn't register the quarantine approval, and the dialog comes up every time karabiner opens it
sudo xattr -rd com.apple.quarantine '/Applications/Visual Studio Code.app'

#  Hide some login elements
cp "./.hushlogin" "$HOME/.hushlogin"

# Kill affected apps
inform "Resetting affected processes"
for app in "Dock" "Finder" "SystemUIServer" "ControlStrip"; do killall "${app}" >/dev/null 2>&1; done

inform "You're done! Congratulations! You'll need to reboot to see some changes take effect. Please do that now :)"
