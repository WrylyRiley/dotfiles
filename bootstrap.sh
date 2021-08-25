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
{ which xcode-select &>/dev/null && error "xcode developer tools already installed"; } || { inform "Installing xcode developer tools" && xcode-select --install; }
# Activate xcode terminal tools
inform "Enabling xcode-select tooling"
sudo xcode-select -s /Applications/Xcode.app/Contents/Developer
install_homebrew
{ [[ $HOMEBREW == y ]] && sh ./homebrew-apps.sh; } || error "No changes made to homebrew"
{ [[ $RSA == y ]] && sh ./rsa.sh; } || error "Not installing RSA keys"
{ [[ $MACSTORE == y ]] && sh ./mac-apps.sh; } || error "Not installing Mac store apps"
{ [[ $ITERM == y ]] && sh ./iterm.sh; } || error "Not updating iTerm preferences"
{ [[ $GIT == y ]] && sh ./git-settings.sh; } || error "Not updating git settings"
{ [[ $CHANGEDOCK == y ]] && sh ./dock-settings.sh; } || error "Not modifying dock"
{ [[ $DEFAULTS == y ]] && sh ./system.sh; } || error "Not changing system preferences"
{ [[ $NODEMOD == y ]] && sh ./nvm.sh; } || error "Not installing nvm or global node modules"
{ [[ $ZSHELL == y ]] && sh ./zshell.sh; } || error "Not configuring zsh"

cp "./config/.hushlogin" "$HOME/.hushlogin"

read -n 1 -p "$(echo $C"\nReboot now?  y/n  "$R)" REBOOT
{ [[ $REBOOT == y ]] && inform "Rebooting now..." && sudo reboot; }

sh ./cleanup.sh
inform "You're done! Congratulations! You'll need to reboot to see some changes take effect. Please do that now :)"
. $HOME/.zshrc
exit 0
