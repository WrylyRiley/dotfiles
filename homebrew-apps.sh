
. ./helpers.sh
# Formulae and casks
formulae=(
    dockutil
    mas
    p7zip
    python3
    shfmt
    thefuck
    wget
    xcv
    
)
common_casks=(
    1password
    1password-cli
    homebrew/cask/docker
    homebrew/cask/flux
    gimp
    homebrew/cask-fonts/font-fira-code
    homebrew/cask-fonts/font-jetbrains-mono
    homebrew/cask-versions/firefox-developer-edition
    vivaldi
    insomnia
    iterm2
    slack
    swiftbar
    telegram-desktop
    tidal
    visual-studio-code
)
personal_casks=(
    steam
    discord
)
# Homebrew
inform "Installing formulae"
pour_formulae "${formulae[@]}"
inform "Installing casks"
tap_casks "${common_casks[@]}"
[[ $PERSONAL == y ]] && inform "Installing personal casks" && tap_casks "${personal_casks[@]}"
