#!/bin/zsh
ARM=false
DARWIN=false

if [[ -e /Applications/Privileges.app ]]; then
  alias sudo="/Applications/Privileges.app/Contents/Resources/PrivilegesCLI --add && sudo"
  alias brew="/Applications/Privileges.app/Contents/Resources/PrivilegesCLI --add && brew"
fi

##################################
# Helpers                        #
##################################
# Get sudo early
error() { printf "\x1b[1;31m❌ $1\x1b[0m\n"; }
inform() { printf "\x1b[1;34m💡 $1\x1b[0m\n"; }
success() { printf "\x1b[1;32m✅ $1\x1b[0m\n"; }
[[ $(arch) == 'arm64' ]] && ARM=true
[[ $(uname) == 'Darwin' ]] && DARWIN=true

##################################
# XCode terminal tools           #
##################################
xcdevtools=$(
  xcode-select -p 1>/dev/null
  echo $?
)
if [[ $xcdevtools == 0 ]]; then
  inform "xcode developer tools already installed"
else
  sudo xcode-select --install
  success "Installed xcode developer tools"
  sudo xcode-select -s /Applications/Xcode.app/Contents/Developer
  sudo xcodebuild -license accept
  success "Enabled xcode-select tooling"
fi

##################################
# Homebrew                       #
##################################
# Install homebrew if it isn't already
brew -v &>/dev/null && inform "Homebrew already installed..." || {
  echo | NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  success "Installed homebrew"
}

# Add homebrew to the path
if ! command -v 'brew' &>/dev/null; then
  [[ $ARM == true ]] && PATH="/opt/homebrew/bin/brew:$PATH" || BREW_PATH="/usr/local/bin/brew:$PATH"
  success "Added homebrew to PATH"
else
  success "Homebrew found in path"
fi

# Install 1password first so we can log into the mac app store
inform "Ensuring 1Password is installed. Use this opportunity to get your SSH and GPG keys in ~"
[[ ! -e /Applications/1Password.app ]] && brew install --quiet --cask 1password

# Install the rest of the brew applications
inform "Running brew installations"
brew tap homebrew/cask
brew tap homebrew/cask-fonts
brew tap homebrew/cask-versions
brew tap homebrew/cask-drivers

brew install --quiet \
  asdf cloudflared convox direnv duti fzf gnupg grepcidr \
  jenv mas p7zip python3 shfmt tldr thefuck watchman wget xcv

HOMEBREW_NO_AUTO_UPDATE=1 brew install --quiet --cask \
  android-studio beekeeper-studio docker firefox-developer-edition \
  flipper flux font-fira-code font-jetbrains-mono gimp insomnia iterm2 \
  karabiner-elements logitech-camera-settings meetingbar slack spotify \
  telegram-desktop visual-studio-code vivaldi zoom

success "Finished brew installations"

##################################
# Mac App Store                  #
##################################
#  Install magnet from the app store if it isn't present
if [[ ! -e /Applications/Magnet.app ]]; then
  mas install 441258766
fi

#  Install Amphetamine from the app store if it isn't present
if [[ ! -e /Applications/Amphetamine.app ]]; then
  mas install 937984704
fi

##################################
# SSH agent, SSH key             #
##################################
mkdir -p $HOME/.ssh
if [[ ! -e ~/.ssh/id_ed25519 ]] && [[ ! -e ~/.ssh/id_ed25519.pub ]] && [[ -e ~/id_ed25519 ]] && [[ -e ~/id_ed25519.pub ]]; then
  mv ~/id_ed25519 ~/.ssh/
  mv ~/id_ed25519.pub ~/.ssh/
  eval "$(ssh-agent -s)"
  touch $HOME/.ssh/config
  chmod 400 $HOME/.ssh/id_ed25519.pub $HOME/.ssh/id_ed25519
  echo "Host *
    AddKeysToAgent yes
    UseKeychain yes
    IdentityFile ~/.ssh/id_ed25519" >$HOME/.ssh/config
  [[ $ARM == true ]] && ssh-add --apple-use-keychain $HOME/.ssh/id_ed25519 || ssh-add -K $HOME/.ssh/id_ed25519
  success "Added key to ssh-agent"
else
  inform "SSH keys found. Skipping..."
fi
##################################
# GPG key                        #
##################################
if [[ $(gpg --list-secret-keys --keyid-format=long | grep 392632) ]] && [[ -e ~/secret-key-backup.asc ]] && [[ -e ~/trustdb-backup.txt ]]; then
  gpg --import $HOME/secret-key-backup.asc
  gpg --import-ownertrust <$HOME/trustdb-backup.txt
  rm $HOME/secret-key-backup.asc
  rm $HOME/trustdb-backup.txt
  success "Imported found GPG key and Trust DB"
else
  inform "GPG key not found. Skipping..."
fi

##################################
# iTerm2 Preferences             #
##################################
plistdir=$HOME/Library/Application\ Support/iTerm2/DynamicProfiles
mkdir -p $plistdir
if [[ ! -e "$plistdir/profiles.plist" ]]; then
  inform "iTerm profile not found. Setting iTerm profile and preferences"
  cp -f "./itermProfiles.json" "${plistdir}/profiles.plist"
  success "iTerm preferences copied. Make sure you change your default profile in iTerm. Also, consider changing non-profile settings like preventing automatic copying on text selection, and natural typing"
fi

##################################
# Git Preferences                #
##################################
if [[ ! -e $HOME/.gitconfig ]]; then
  cp ./.gitconfig $HOME/.gitconfig
  inform "Copied .gitconfig to ~"
fi

##################################
# Python modules                 #
##################################
# Needed to do physical device debuging with Flipper
# if [[ $(
#   pip3 list | 1>/dev/null
#   echo $?
# ) ]]; then
#   pip3 install fb-idb
#   success "Installed IDB client for Flipper debugging"
# fi

##################################
# zsh, plugins, settings         #
##################################
export ZSHCONFIG="$HOME/.config/zsh"
mkdir -p $ZSHCONFIG
if [[ ! -d $ZSHCONFIG/zsh-syntax-highlighting ]]; then
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSHCONFIG
  success "Installed zsh syntax highlighting"
else
  inform "zsh syntax highlighting already installed. Run updatePlugins to pull changes"
fi

if [[ ! -d $ZSHCONFIG/zsh-autosuggestions ]]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSHCONFIG
  success "Installed zsh autosuggestions"
else
  inform "zsh autosuggestions already installed. Run updatePlugins to pull changes"
fi

if [[ ! -d $ZSHCONFIG/zsh-completions ]]; then
  git clone https://github.com/zsh-users/zsh-completions.git $ZSHCONFIG
  success "Installed zsh completions"
else
  inform "zsh completions already installed. Run updatePlugins to pull changes"
fi

if [[ ! -e $ZSHCONFIG/static_aliases.zsh ]]; then
  cp ./static_aliases.zsh $ZSHCONFIG
  success "Copied static aliases"
else
  inform "Static aliases already installed."
fi

if [[ ! -e $ZSHCONFIG/rileyb.zsh-theme ]]; then
  cp ./rileyb.zsh-theme $ZSHCONFIG
  success "installed rileyb theme"
fi

if [[ ! -e $ZSHCONFIG/agnoster.zsh-theme ]]; then
  cp ./agnoster.zsh-theme $ZSHCONFIG
  success "installed agnoster theme"
fi

cp $HOME/.zshrc $HOME/.zshrc.bak
success "Backed up ~/.zshrc to ~/.zshrc.bak"
cp ./.zshrc $HOME/.zshrc
success "Copied new .zshrc config"

##################################
# System settings                #
##################################
# These are confirmed to work in Big Sur

# Dock shortcuts
dockApps=("Privileges" "Visual Studio Code" "iTerm" "Vivaldi"
  "Insomnia" "Flipper" "Beekeeper Studio" "Slack" "Discord" "Spotify"
  "zoom.us" "Cricut Design Space" "Telegram Desktop" "1Password"
  "Steam" "Android Studio" "XCode")
# Not on homebrew yet for some reason

if ! $(command -v 'dockutil' &>/dev/null); then
  curl -L https://github.com/kcrawford/dockutil/releases/download/3.0.2/dockutil-3.0.2.pkg --output ~/Downloads/dockutil-3.0.2.pkg
  sudo installer -pkg ~/Downloads/dockutil-3.0.2.pkg -target /
  success "Installed dockutil pkg"
fi
dockutil --remove all
for app in "${dockApps[@]}"; do
  [[ -d "/Applications/${app}.app" ]] && dockutil --add "/Applications/${app}.app"
done
dockutil --add '~/Downloads' --view list --display folder
dockutil --add '~/programming' --view list --display folder
success "Set dock shortcuts"

dockSettings=("autohide -int 1" "autohide-time-modifier -float 0.5"
  "autohide-delay -float 0" "magnification -int 0" "mineffect -string scale"
  "minimize-to-application -int 1" "mru-spaces -int 0" "showDesktopGestureEnabled -int 1"
  "showhidden -int 1" "showLaunchpadGestureEnabled -int 0"
  "showMissionControlGestureEnabled -int 1" "show-process-indicators -int 1"
  "show-recents -int 0" "tilesize -int 50")

for action in "${dockSettings[@]}"; do
  $(defaults write com.apple.dock ${action} &>/dev/null &)
done
success "Updated dock settings"

# Mouse Settings
trackpadSettings=("showLaunchpadGestureEnabled -int 0" "ActuateDetents -int 1"
  "Clicking -int 0" "DragLock -int 0" "Dragging -int 0" "FirstClickThreshold -int 1"
  "ForceSuppressed -int 0" "SecondClickThreshold -int 1" "TrackpadCornerSecondaryClick -int 0"
  "TrackpadFiveFingerPinchGesture -int 2" "TrackpadFourFingerHorizSwipeGesture -int 2"
  "TrackpadFourFingerPinchGesture -int 2" "TrackpadFourFingerVertSwipeGesture -int 2"
  "TrackpadHandResting -int 1" "TrackpadHorizScroll -int 1" "TrackpadMomentumScroll -int 1"
  "TrackpadPinch -int 1" "TrackpadRightClick -int 1" "TrackpadRotate -int 1" "TrackpadScroll -int 1"
  "TrackpadThreeFingerDrag -int 0" "TrackpadThreeFingerHorizSwipeGesture -int 2"
  "TrackpadThreeFingerTapGesture -int 2" "TrackpadThreeFingerVertSwipeGesture -int 2"
  "TrackpadTwoFingerDoubleTapGesture -int 1" "TrackpadTwoFingerFromRightEdgeSwipeGesture -int 0"
  "USBMouseStopsTrackpad -int 0")

for action in "${trackpadSettings[@]}"; do
  $(defaults write com.apple.AppleMultitouchTrackpad $action &>/dev/null &)
done

defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerTapGesture -bool false
success "Updated trackpad settings"

# Global Settings
globalSettings=("AppleEnableSwipeNavigateWithScrolls -int 1"
  "AppleHighlightColor -string '0.752941 0.964706 0.678431'"
  "AppleInterfaceStyleSwitchesAutomatically -int 1" "ApplePressAndHoldEnabled -int 0"
  "AppleScrollerPagingBehavior -int 1" "AppleShowAllExtensions -int 1"
  "CGFontRenderingFontSmoothingDisabled -int 0" "com.apple.trackpad.scaling -int 1"
  "com.apple.sound.beep.feedback -float 0" "com.apple.swipescrolldirection -int 1"
  "ContextMenuGesture -int 1" "InitialKeyRepeat -int 15" "KeyRepeat -int 2"
  "NSAutomaticCapitalizationEnabled -int 0" "NSAutomaticPeriodSubstitutionEnabled -int 1"
  "NSNavPanelExpandedStateForSaveMode -int 1" "NSTableViewDefaultSizeMode -int 2"
  "PMPrintingExpandedStateForPrint -int 1")

for action in "${globalSettings[@]}"; do
  $(defaults write -g $action &>/dev/null &)
done

defaults write com.apple.LaunchServices LSQuarantine -int -0
success "Updated global mac settings"

# Finder Settings
finderSettings=("AppleShowAllFiles -int 1" "EmptyTrashSecurely -int 1" "FXEnableRemoveFromICloudDriveWarning -int 0"
  "FXEnableExtensionChangeWarning -int 0" "FXICloudDriveDesktop -int 0" "FXICloudDriveDocuments -int 0"
  "FXICloudDriveEnabled -int 1" "FXPreferredViewStyle -string Nlsv" "_FXShowPosixPathInTitle -int 1"
  "ShowExternalHardDrivesOnDesktop -int 1" "ShowHardDrivesOnDesktop -int 1" "ShowPathbar -int 1"
  "ShowRemovableMediaOnDesktop -int 1" "ShowSidebar -int 1" "ShowStatusBar -int 1" "SidebarWidth -int 220")

for action in "${finderSettings[@]}"; do
  $(defaults write com.apple.finder $action &>/dev/null &)
done
success "Updated finder settings"

# Control Center Settings
controlCenterSettings=("'NSStatusItem Visible DoNotDisturb' -int 0" "'NSStatusItem Visible AirDrop' -int 0"
  "'NSStatusItem Visible Battery' -int 0" "'NSStatusItem Visible Clock' -int 0"
  "'NSStatusItem Visible NowPlaying' -int 0" "'NSStatusItem Visible ScreenMirroring' -int 0"
  "'NSStatusItem Visible WiFi' -int 0")

for action in "${controlCenterSettings[@]}"; do
  $(defaults write com.apple.controlcenter $action &>/dev/null &)
done
success "Updated menu bar settings"

defaults write com.apple.Spotlight "NSStatusItem Visible Item-0" -int 0
defaults write com.apple.appstore ShowDebugMenu -int 1
success "Showing debug menu in Mac store"

chflags nohidden $HOME/Library
success "Unhid ~/Library"

defaults write com.apple.commerce AutoUpdate -int 1
success "Enabled app store auto-updates"

defaults write com.microsoft.VSCode CGFontRenderingFontSmoothingDisabled -int 0
success "Enabled subpixel antialiasing in VSCode"

if [[ ! -d $HOME/Screen\ Shots ]]; then
  mkdir -p $HOME/Screen\ Shots
fi

defaults write com.apple.screencapture location $HOME/Screen\ Shots
success "Set screnshot directory to ~/Screenshots"

if [[ ! -e $HOME/programming ]]; then
  mkdir -p $HOME/programming
  success "Created ~/programming"
else
  inform "~/programming found"
fi

defaults write $HOME/Library/Preferences/com.apple.controlstrip MiniCustomized '(com.apple.system.screen-lock, com.apple.system.mute, com.apple.system.volume, com.apple.system.brightness )'
defaults write $HOME/Library/Preferences/com.apple.controlstrip FullCustomized '(com.apple.system.airplay, com.apple.system.group.keyboard-brightness, com.apple.system.group.brightness, com.apple.system.group.media, com.apple.system.group.volume, com.apple.system.sleep )'
inform "Set touchbar preferences"

inform "Setting file associations for VSCode"
vscodeExt=(".sh" ".css" ".js" ".jsx" ".ts" ".tsx" ".xml" ".yaml" ".json" ".md" ".py" ".txt")
for action in $vscodeExt; do
  $(duti -s com.microsoft.VSCode $action all &>/dev/null &)
done
success "Set file associations for VSCode"

karabiner=$HOME/.config/karabiner
mkdir -p $karabiner
if [[ ! -e $karabiner/karabiner.json ]]; then
  cp ./karabiner.json $HOME/.config/karabiner
  success "Configured Karabiner Elements"
fi

# Native Messaging needs to be enabled to allow 1Password to find Vivaldi
# While chrome does this automatically, Vivaldi does not. This is the fix
msgDir=$HOME/Library/Application\ Support/Google/Chrome
if [[ ! -d $msgDir ]]; then
  mkdir -p $msgDir
  success "Enabled native messaging for Vivaldi 1Password integration"

fi

if [[ ! -e $HOME/programming/truebill-native.code-workspace ]]; then
  cp ./truebill-native.code-workspace $HOME/programming
  success "Copied common truebill native workspace file to ~/programming"
else
  inform "Found truebill-native workspace file to ~/programming"
fi

if [[ ! -e $HOME/programming/truebill.code-workspace ]]; then
  cp ./truebill.code-workspace $HOME/programming
  success "Copied common truebill workspace file to ~/programming"
else
  inform "Found truebill workspace file to ~/programming"
fi

sudo xattr -rd com.apple.quarantine '/Applications/Visual Studio Code.app'
success "Unquarantined VSCode via Karabiner"

if [[ ! -e $HOME/.hushlogin ]]; then
  cp "./.hushlogin" "$HOME/.hushlogin"
  success "Hid login message in shell with .hushlogin"
else
  inform "~/.hushlogin found"
fi
