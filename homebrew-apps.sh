. ./helpers.sh
# Formulae and casks
formulae=(dockutil mas p7zip python3 shfmt thefuck wget xcv duti tldr)
common_casks=(1password 1password-cli gimp docker flux font-fira-code font-jetbrains-mono firefox-developer-edition karabiner-elements meetingbar insomnia iterm2 sequel-ace slack telegram-desktop tidal tunnelblick visual-studio-code vivaldi zoom)
personal_casks=(steam discord)
brew tap homebrew/cask
brew tap homebrew/cask-fonts
brew tap homebrew/cask-versions
inform "Installing formulae" && pour_formulae "${formulae[@]}"
inform "Installing casks" && tap_casks "${common_casks[@]}"
[[ $PERSONAL == y ]] && inform "Installing personal casks" && tap_casks "${personal_casks[@]}"
