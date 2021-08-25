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
    duti
)
common_casks=(
    1password
    1password-cli
    gimp
    docker
    flux
    font-fira-code
    font-jetbrains-mono
    firefox-developer-edition
    meetingbar
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
brew tap homebrew/cask
brew tap homebrew/cask-fonts
brew tap homebrew/cask-versions
inform "Installing formulae"
pour_formulae "${formulae[@]}"
inform "Installing casks"
tap_casks "${common_casks[@]}"
[[ $PERSONAL == y ]] && inform "Installing personal casks" && tap_casks "${personal_casks[@]}"
