. ./helpers.sh

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

# Show the ~/Library folder
inform "Unhiding ~/Library"
chflags nohidden ~/Library

# Enable app auto-update
inform "Enable app store auto-updates"
defaults write com.apple.commerce AutoUpdate -int 1

# Enable subpixel antialiasing in VSCode
inform "ENable subpixel antialiasing in VSCode"
defaults write com.microsoft.VSCode CGFontRenderingFontSmoothingDisabled -int 0

# Set Vivaldi as the default browser
inform "Setting Vivaldi as default browser"
defbro com.vivaldi.Vivaldi

# Set a new location for screenshots
inform "Setting screnshot directory"
mkdir -p ~/Screen\ Shots
defaults write com.apple.screencapture location ~/Screen\ Shots

# Change the setting on the touchbar
inform "Setting touchbar preferences"
defaults write ~/Library/Preferences/com.apple.controlstrip MiniCustomized '(com.apple.system.screen-lock, com.apple.system.mute, com.apple.system.volume, com.apple.system.brightness )'
defaults write ~/Library/Preferences/com.apple.controlstrip FullCustomized '(com.apple.system.airplay, com.apple.system.group.keyboard-brightness, com.apple.system.group.brightness, com.apple.system.group.media, com.apple.system.group.volume, com.apple.system.sleep )'

# Change File Associations
inform "Setting file associations for VSCode"
duti -s com.microsoft.VSCode .sh all
duti -s com.microsoft.VSCode .html all
duti -s com.microsoft.VSCode .htm all
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
mkdir -p ~/.config/Karabiner
cp ./config/karabiner.json ~/.config/karabiner

# Vivaldi configuration
# Native Messaging needs to be enabled to allow 1Password to find Vivaldi
# While chrome does this automatically, Vivaldy does not. This is the fix

mkdir -p ~/Library/Application\ Support/Google/Chrome

# Kill affected apps
inform "Resetting affected processes"
for app in "Dock" "Finder" "SystemUIServer" "ControlStrip"; do killall "${app}" >/dev/null 2>&1; done
