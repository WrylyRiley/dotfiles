#!/bin/zsh
arm=false
work=false
force=false
acc=FPFJUFQ7XJFX7ES36O3AD324Y4

usage() {
  cat <<EOF
usage: $0 -w work

This script runs a general dotfiles setup.
It will change as little as posible depending on existing system configuration

OPTIONS:
    -w  Sets personal options to install like Steam and personal github settings
    -h  Show this message
EOF
}

while getopts “:hfw” OPTION; do
  case $OPTION in
  h)
    usage
    exit 1
    ;;
  w)
    work=true
    ;;
  ?)
    usage
    exit
    ;;
  esac
done

##################################
# Helpers                        #
##################################
error() { printf "\x1b[1;31m❌ $1\x1b[0m\n"; }
inform() { printf "\x1b[1;34m💡 $1\x1b[0m\n"; }
success() { printf "\x1b[1;32m✅ $1\x1b[0m\n"; }

if [[ work=true && -e /Applications/Privileges.app ]]; then
  alias sudo="/Applications/Privileges.app/Contents/Resources/PrivilegesCLI --add &> /dev/null && sudo"
  alias brew="/Applications/Privileges.app/Contents/Resources/PrivilegesCLI --add &> /dev/null && brew"
fi

[[ $(arch) == 'arm64' ]] && arm=true

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
if brew -v &>/dev/null; then
  inform "Homebrew already installed..."
else
  echo | NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  success "Installed homebrew"
fi

# Add homebrew to the path
if ! command -v 'brew' &>/dev/null; then
  [[ $arm == true ]] && PATH="/opt/homebrew/bin/brew:$PATH" || BREW_PATH="/usr/local/bin/brew:$PATH"
  success "Added homebrew to PATH"
else
  inform "Homebrew found in path"
fi

# Install the rest of the brew applications
inform "Running brew installations"

# Tap brew casks
tapped_casks=$(brew tap)
casks=("homebrew/cask" "homebrew/cask-fonts" "homebrew/cask-fonts" "homebrew/cask-drivers")
for cask in "${casks[@]}"; do
  if echo $tapped_casks | grep -qoE "\b${cask}\b"; then
    inform "$cask already tapped"
  else
    brew tap $cask
    success "tapped $cask"
  fi
done

# Install brew formulae
brew_formulae=("asdf" "cloudflared" "convox" "direnv" "duti" "fzf"
  "gnupg" "grepcidr" "mas" "p7zip" "shfmt" "tldr"
  "watchman" "wget" "xcv")
brew_leaves=$(brew leaves)
for formula in "${brew_formulae[@]}"; do
  if echo $brew_leaves | grep -qoE "\b$formula\b"; then
    inform "$formula already installed"
  else
    success "Installing $formula"
    brew install --quiet $formula
  fi
done

# Install brew casks
brew_casks=("1password-cli" "1password" "android-studio" "beekeeper-studio" "docker"
  "firefox-developer-edition" "flipper" "flux" "font-fira-code" "font-jetbrains-mono"
  "gimp" "insomnia" "iterm2" "karabiner-elements" "logitech-camera-settings"
  "meetingbar" "slack" "spotify" "visual-studio-code" "vivaldi" "zoom")
personal_casks=("steam" "discord" "telegram-desktop")

if [[ work=false ]]; then
  brew_casks+="steam"
  brew_casks+="discord"
  brew_casks+="telegram-desktop"
fi

brew_cask_list=$(brew list --cask)
for cask in "${brew_casks[@]}"; do
  if echo $brew_cask_list | grep -qoE "\b$cask\b"; then
    echo "$cask already installed"
  else
    HOMEBREW_NO_AUTO_UPDATE=1 brew install --cask $cask
    echo "installing $cask"
  fi
done

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
inform "Make sure you're signed into 1password and CLI connectivity is turned on or else SSH config fails"
read -p "continue?"

if [[ -e ~/.ssh/id_25519 ]]; then
  inform "Personal SSH key already in the .ssh folder. Skipping..."
else
  inform "Getting personal SSH key from 1Password"
  # Grab the key from 1Password
  op item get "Github SSH key" --fields "private key" | sed -E 's/^.|.$//g' >~/.ssh/id_25519
  op item get "Github SSH key" --fields "public key" | sed -E 's/^.|.$//g' >~/.ssh/id_25519.pub
  # Set the permissions
  chmod 600 ~/.ssh/Rocket Moneyid_25519 2>/dev/null
  chmod 644 ~/.ssh/id_25519.pub 2>/dev/null
  eval "$(ssh-agent -s)"
  [[ $ARM == true ]] && ssh-add --apple-use-keychain $HOME/.ssh/id_ed25519 || ssh-add -K $HOME/.ssh/id_ed25519
fi

if [[ $work = true ]]; then
  op --account $acc item get "Github SSH key" --fields "public key" | sed -E 's/^.|.$//g' >~/.ssh/id_25519.pub
  error "Due to limitations of this CLI, you cannot download your work key to use as a fallback. 
You can export it from 1Password manually where you'll need to enter the associated passphrase.
This tool will however still export the proper config to use 1Password for key authentication
"
  # Write work config
  success "Copying work gitconfig to ~/.gitconfig"
  cp ./git/.gitconfig_work ~/.gitconfig
else
  # Write personal config
  success "Copying personal gitconfig to ~/.gitconfig"
  cp ./git/.gitconfig ~/.gitconfig
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
# zsh, plugins, settings         #
##################################
export ZSHCONFIG="$HOME/.config/zsh"
mkdir -p $ZSHCONFIG
dir=$ZSHCONFIG/zsh-syntax-highlighting
if [[ ! -d $dir ]]; then
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $dir
  success "Installed zsh syntax highlighting"
else
  inform "zsh syntax highlighting already installed. Run updatePlugins to pull changes"
fi

dir=$ZSHCONFIG/zsh-autosuggestions
if [[ ! -d $dir ]]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions.git $dir
  success "Installed zsh autosuggestions"
else
  inform "zsh autosuggestions already installed. Run updatePlugins to pull changes"
fi

dir=$ZSHCONFIG/zsh-completions
if [[ ! -d $dir ]]; then
  git clone https://github.com/zsh-users/zsh-completions.git $dir
  success "Installed zsh completions"
else
  inform "zsh completions already installed. Run updatePlugins to pull changes"
fi

dir=$ZSHCONFIG/zsh-history-substring-search
if [[ ! -d $dir ]]; then
  git clone https://github.com/zsh-users/zsh-history-substring-search.git $dir
  success "Installed zsh history substring search"
else
  inform "zsh history string subsearch already installed. Run updatePlugins to pull changes"
fi

if [[ ! -e $ZSHCONFIG/static_aliases.zsh ]]; then
  cp ./zsh/static_aliases.zsh $ZSHCONFIG
  success "Copied static aliases"
else
  inform "Static aliases already installed."
fi

if [[ ! -e $ZSHCONFIG/rileyb.zsh-theme ]]; then
  cp ./zsh/rileyb.zsh-theme $ZSHCONFIG
  success "installed rileyb theme"
fi

if [[ ! -e $ZSHCONFIG/agnoster.zsh-theme ]]; then
  cp ./zsh/agnoster.zsh-theme $ZSHCONFIG
  success "installed agnoster theme"
fi

cp $HOME/.zshrc "$ZSHCONFIG/.zshrc_$(date "+ %a_%b_%Y_%e_%H:%M:%S")"
success "Backed up ~/.zshrc to ~/.config/.zsh/.zshrc[DATE]"

cp ./zsh/.zshrc $HOME/.zshrc
if [[ work=true ]]; then
  cat ./zsh/.zshrc_work ~/.zshrc
fi
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

for app in "${dockApps[@]}"; do
  [[ -d "/Applications/${app}.app" ]] && dockutil --add "/Applications/${app}.app" --no-restart --replacing "${app}" &>/dev/null
done

dockutil --add '~/Downloads' --view list --display folder --replacing "Downloads" &>/dev/null
dockutil --add '~/programming' --view list --display folder --replacing "programming" &>/dev/null
success "Set dock shortcuts"

for app in "${dockApps[@]}"; do
  appDir="/Applications/${app}.app"
  if [[ -e $appDir ]]; then
    quarantine=$(xattr "${appDir}" | grep com.apple.quarantine)
    if [[ $quarantine = "com.apple.quarantine" ]]; then
      sudo xattr -rd com.apple.quarantine "${appDir}"
      success "${app} successfully unquarantined"
    else
      inform "${app} is already unquarantined"
    fi
  fi
done

updateDefaultsSetting() {
  property=$(echo ${1} | sed 's/ .*//')
  result=$(defaults read ${2} $property)
  if echo $1 | grep -qoE ".*$result$"; then
    inform "${property} already set"
  else
    success "writing new setting"
    $(defaults write ${2} ${action} &>/dev/null &)
  fi
}

dockSettings=("autohide -int 1" "autohide-time-modifier -float 0.5"
  "autohide-delay -float 0" "magnification -int 0" "mineffect -string scale"
  "minimize-to-application -int 1" "mru-spaces -int 0" "showDesktopGestureEnabled -int 1"
  "showhidden -int 1" "showLaunchpadGestureEnabled -int 0"
  "showMissionControlGestureEnabled -int 1" "show-process-indicators -int 1"
  "show-recents -int 0" "tilesize -int 50")

for action in "${dockSettings[@]}"; do
  updateDefaultsSetting "${action}" "com/apple.dock"
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
  updateDefaultsSetting "${action}" "com.apple.AppleMultitouchTrackpad"
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
  updateDefaultsSetting "${action}" "-g"
done
updateDefaultsSetting "LSQuarantine -int -0" "com.apple.LaunchServices "
success "Updated global Mac settings"

# Finder Settings
finderSettings=("AppleShowAllFiles -int 1" "EmptyTrashSecurely -int 1" "FXEnableRemoveFromICloudDriveWarning -int 0"
  "FXEnableExtensionChangeWarning -int 0" "FXICloudDriveDesktop -int 0" "FXICloudDriveDocuments -int 0"
  "FXICloudDriveEnabled -int 1" "FXPreferredViewStyle -string Nlsv" "_FXShowPosixPathInTitle -int 1"
  "ShowExternalHardDrivesOnDesktop -int 1" "ShowHardDrivesOnDesktop -int 1" "ShowPathbar -int 1"
  "ShowRemovableMediaOnDesktop -int 1" "ShowSidebar -int 1" "ShowStatusBar -int 1" "SidebarWidth -int 220")

for action in "${finderSettings[@]}"; do
  updateDefaultsSetting "${action}" "com.apple.finder"
done
success "Updated finder settings"

# Control Center Settings
controlCenterSettings=("'NSStatusItem Visible DoNotDisturb' -int 0" "'NSStatusItem Visible AirDrop' -int 0"
  "'NSStatusItem Visible Battery' -int 0" "'NSStatusItem Visible Clock' -int 0"
  "'NSStatusItem Visible NowPlaying' -int 0" "'NSStatusItem Visible ScreenMirroring' -int 0"
  "'NSStatusItem Visible WiFi' -int 0")

for action in "${controlCenterSettings[@]}"; do
  updateDefaultsSetting "${action}" "com.apple.controlcenter"
done
success "Updated menu bar settings"

updateDefaultsSetting "ShowDebugMenu -int 1" "com.apple.appstore"
success "Showing debug menu in Mac store"

chflags nohidden $HOME/Library
success "Unhid ~/Library"

updateDefaultsSetting "AutoUpdate -int 1" "com.apple.commerce"
success "Enabled app store auto-updates"

updateDefaultsSetting "CGFontRenderingFontSmoothingDisabled -int 0" "com.microsoft.VSCode "
success "Enabled subpixel antialiasing in VSCode"

screenshotDir=$(defaults read com.apple.screencapture location | grep "Screen Shots")
if [[ ! screenshotDir = "" ]]; then
  inform "Screenshot directory arleady set to ${screenshotDir}"
else
  mkdir -p $HOME/Screen\ Shots
  defaults write com.apple.screencapture location $HOME/Screen\ Shots
  success "Set screnshot directory to ~/Screen Shots"
fi

if [[ ! -e $HOME/programming ]]; then
  mkdir -p $HOME/programming
  success "Created ~/programming"
else
  inform "~/programming found"
fi

if [[ -e $HOME/Library/Preferences/com.apple.controlstrip ]]; then
  defaults write $HOME/Library/Preferences/com.apple.controlstrip MiniCustomized '(com.apple.system.screen-lock, com.apple.system.mute, com.apple.system.volume, com.apple.system.brightness )'
  defaults write $HOME/Library/Preferences/com.apple.controlstrip FullCustomized '(com.apple.system.airplay, com.apple.system.group.keyboard-brightness, com.apple.system.group.brightness, com.apple.system.group.media, com.apple.system.group.volume, com.apple.system.sleep )'
  inform "Set touchbar preferences"
fi

vscodeExt=(".sh" ".css" ".js" ".jsx" ".ts" ".tsx" ".xml" ".yaml" ".json" ".md" ".py" ".txt")
for action in ${vscodeExt[@]}; do
  $(duti -s com.microsoft.VSCode $action all &>/dev/null &)
done
success "Set file associations for VSCode"

karabiner=$HOME/.config/karabiner
mkdir -p $karabiner
if [[ ! -e $karabiner/karabiner.json ]]; then
  cp ./karabiner.json $karabiner
  success "Configured Karabiner Elements"
else
  inform "Karabiner config found"
fi

# Native Messaging needs to be enabled to allow 1Password to find Vivaldi
# While chrome does this automatically, Vivaldi does not. This is the fix
msgDir=$HOME/Library/Application\ Support/Google/Chrome
if [[ ! -d $msgDir ]]; then
  mkdir -p $msgDir
  success "Enabled native messaging for Vivaldi 1Password integration"
else
  inform "Vivaldi native messaging enabled"
fi

if [[ ! -e $HOME/programming/dotfiles.code-workspace ]]; then
  cp ./workspaces/dotfiles.code-workspace $HOME/programming
  success "Copied dotfiles workspace file to ~/programming"
else
  inform "Found dotfiles workspace file in ~/programming"
fi

if [[ work=true ]]; then
  if [[ ! -e $HOME/programming/rocketmoney-mobile.code-workspace ]]; then
    cp ./workspaces/rocketmoney-mobile.code-workspace $HOME/programming
    success "Copied rocketmoney mobile workspace file to ~/programming"
  else
    inform "Found rocketmoney-mobile workspace file in ~/programming"
  fi

  if [[ ! -e $HOME/programming/rocketmoney.code-workspace ]]; then
    cp ./workspaces/rocketmoney.code-workspace $HOME/programming
    success "Copied rocketmoney workspace file to ~/programming"
  else
    inform "Found rocketmoney workspace file in ~/programming"
  fi
fi

if [[ ! -e $HOME/.hushlogin ]]; then
  cp "./.hushlogin" "$HOME/.hushlogin"
  success "Hid login message in shell with .hushlogin"
else
  inform "~/.hushlogin found"
fi

for app in "Dock" "Finder" "SystemUIServer" "ControlStrip"; do killall "${app}" >/dev/null 2>&1; done
success "Restarted affected processes"
