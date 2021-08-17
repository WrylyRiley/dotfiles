# Initialization
. ./global-vars.sh
. ./helpers.sh
clear
# Modifiers
read -n 1 -p "$(echo $C"\nIs this your personal Mac?  y/n  ")" PERSONAL
read -n 1 -p "$(echo "\nInstall Homebrew casks & formulae?  y/n  ")" HOMEBREW
read -n 1 -p "$(echo "\nInstall global node modules?  y/n  ")" NODEMOD
read -n 1 -p "$(echo "\nDownload Mac store apps?  y/n  ")" MACSTORE
read -n 1 -p "$(echo "\nChange dock icons?  y/n  ")" CHANGEDOCK
read -n 1 -p "$(echo "\nUpdate iTerm preferences?  y/n  ")" ITERM
read -n 1 -p "$(echo "\nConfigure zsh?  y/n  ")" ZSHELL
read -n 1 -p "$(echo "\nInstall RSA keys?  y/n  ")" RSA
read -n 1 -p "$(echo "\nUpdate git user name and email?  y/n  ")" GIT
read -n 1 -p "$(echo "\nChange system preferences?  y/n  "$R)" DEFAULTS
[[ ! -d $HOME/programming ]] && mkdir $HOME/programming
clear
# Terminal developer tools
{ which xcode-select >/dev/null && error "xcode developer tools already installed"; } || { inform "Installing xcode developer tools" && xcode-select --install; }
# Install Homebrew
install_homebrew
# Install homebrew formulae and casks
{ [[ $HOMEBREW == y ]] && inform "Installing homebrew applications" && sh ./homebrew-apps.sh; } || error "No changes made to homebrew"
# RSA Keys
{ [[ $RSA == y ]] && inform "Installing RSA keys" && sh ./rsa.sh; } || error "Not installing RSA keys"
# Mac store apps
{ [[ $MACSTORE == y ]] && inform "Installing Mac store apps" && sh ./mac-apps.sh; } || error "Not installing Mac store apps"
# iTerm2 Preferences
{ [[ $ITERM == y ]] && inform "Updating iTerm preferences" && sh ./iterm.sh; } || error "Not updating iTerm preferences"
# Git Settings
{ [[ $GIT == y ]] && inform "Updating git settings" && sh ./git-settings.sh; } || error "Not updating git settings"
# Change dock shortcuts
{ [[ $CHANGEDOCK == y ]] && inform "Modifying Dock" && sh ./dock-settings.sh; } || error "Not modifying dock"
# Apple configuration
{ [[ $DEFAULTS == y ]] && inform "Setting Mac preferences" && sh ./mac-defaults.sh; } || error "Not changing system preferences"
# Global Node Modules
{ [[ $NODEMOD == y ]] && inform "Installing nvm and global node modules" && sh ./nvm.sh; } || error "Not installing nvm or global node modules"
# oh-my-zsh
{ [[ $ZSHELL == y ]] && inform "Configuring zsh" && sh ./zshell.sh; } || error "Not configuring zsh"
# Finish
cp "./config/.hushlogin" "$HOME/.hushlogin"
sh ./cleanup.sh
inform "You're done! Congratulations! You'll need to sign out to see some changes take effect. Please do that now :)"
. $HOME/.zshrc
exit 0
