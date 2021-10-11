. ./helpers.sh
# Formulae and casks
formulae=(dockutil mas p7zip python3 shfmt thefuck wget xcv duti tldr)
common_casks=(1password 1password-cli gimp docker flipper flux font-fira-code font-jetbrains-mono firefox-developer-edition karabiner-elements logitech-camera-settings meetingbar insomnia iterm2 sequel-ace slack telegram-desktop tidal tunnelblick visual-studio-code vivaldi zoom)
brew tap homebrew/cask
brew tap homebrew/cask-fonts
brew tap homebrew/cask-versions
brew tap homebrew/cask-drivers
inform "Installing formulae" && pour_formulae "${formulae[@]}"
inform "Installing casks" && tap_casks "${common_casks[@]}"
