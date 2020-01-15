######################################################################
# Apple configuration - github.com/pawelgrzybek - github.com/mathiasbynens/
######################################################################

# System Preferences > General > Appearance
defaults write -globalDomain AppleInterfaceStyleSwitchesAutomatically -bool true

# System Preferences > General > Click in the scrollbar to: Jump to the spot that's clicked
defaults write -globalDomain AppleScrollerPagingBehavior -bool true

# System Preferences > General > Sidebar icon size: Medium
defaults write -globalDomain NSTableViewDefaultSizeMode -int 2

# System Preferences > General > Set highlight color to purple
defaults write -globalDomain AppleHighlightColor -string "0.968627 0.831373 1.000000"

# System Preferences > General > Set system-wide dark mode
defaults write -globalDomain AppleInterfaceStyle -string "Dark"

# System Preferences > General > Auto-capitalize off
defaults write -globalDomain NSAutomaticCapitalizationEnabled -int 0

# System Preferences > General > Period Substitution off
defaults write -globalDomain NSAutomaticPeriodSubstitutionEnabled -int 1

# System Preferences > Keyboard > key repeat speed
defaults write -globalDomain KeyRepeat -int 2

# System Preferences > Keyboard > Initial key repeat delay
defaults write -globalDomain InitialKeyRepeat -int 15

# Disable press-and-hold for keys in favor of key repeat
defaults write -globalDomain ApplePressAndHoldEnabled -bool false

# System Preferences > Dock > Size:
defaults write com.apple.dock tilesize -int 36

# System Preferences > Dock > Magnification:
defaults write com.apple.dock magnification -bool true

# System Preferences > Dock > Size (magnified):
defaults write com.apple.dock largesize -int 54

# System Preferences > Dock > Minimize windows using: Scale effect
defaults write com.apple.dock mineffect -string "scale"

# System Preferences > Dock > Minimize windows into application icon
defaults write com.apple.dock minimize-to-application -bool true

# System Preferences > Dock > Automatically hide and show the Dock:
defaults write com.apple.dock autohide -bool true

# System Preferences > Dock > Automatically hide and show the Dock (duration)
defaults write com.apple.dock autohide-time-modifier -float 0.5

# System Preferences > Dock > Automatically hide and show the Dock (delay)
defaults write com.apple.dock autohide-delay -float 0

# System Preferences > Dock > Show indicators for open applications
defaults write com.apple.dock show-process-indicators -bool true

# System Preferences > Trackpad > Tap to click
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true

# Finder > Preferences > Show all filename extensions
defaults write -globalDomain AppleShowAllExtensions -bool true

# Finder: show hidden files by default
defaults write com.apple.finder AppleShowAllFiles -bool true

# Finder: show status bar
defaults write com.apple.finder ShowStatusBar -bool true

# Finder > Preferences > Show wraning before changing an extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Finder > Preferences > Show warning before removing from iCloud Drive
defaults write com.apple.finder FXEnableRemoveFromICloudDriveWarning -bool false

# Finder > View > As List
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Finder > View > Show Path Bar
defaults write com.apple.finder ShowPathbar -bool true

# Completely Disable Dashboard
defaults write com.apple.dashboard mcx-disabled -bool true

# Show the ~/Library folder
chflags nohidden ~/Library

# Kill affected apps
for app in "Dock" "Finder"; do
	killall "${app}" >/dev/null 2>&1
done
