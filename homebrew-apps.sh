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
    gimp
    homebrew/cask/docker
    homebrew/cask/flux
    homebrew/cask-fonts/font-fira-code
    homebrew/cask-fonts/font-jetbrains-mono
    homebrew/cask-versions/firefox-developer-edition
    insomnia
    iterm2
    slack
    telegram-desktop
    tidal
    visual-studio-code
    vivaldi
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
