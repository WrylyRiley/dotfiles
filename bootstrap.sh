# Initialization
. ./global-vars.sh
. ./helpers.sh
clear
# Modifiers
mkdir -p $HOME/programming
mkdir -p $HOME/.ssh

clear
# Terminal developer tools
{ which xcode-select &>/dev/null && error "xcode developer tools already installed"; } || { inform "Installing xcode developer tools" && xcode-select --install; }
# Activate xcode terminal tools
inform "Enabling xcode-select tooling"
sudo xcode-select -s /Applications/Xcode.app/Contents/Developer

install_homebrew

brew bundle install --no-lock
. ./rsa.sh
. ./mac-apps.sh
. ./iterm.sh
. ./git-settings.sh
. ./dock-settings.sh
. ./system.sh
. ./nvm.sh
. ./zshell.sh

cp "./config/.hushlogin" "$HOME/.hushlogin"

read -n 1 -p "$(echo $C"\nReboot now?  y/n  "$R)" REBOOT
{ [[ $REBOOT == y ]] && inform "Rebooting now..." && sudo reboot; }

inform "You're done! Congratulations! You'll need to reboot to see some changes take effect. Please do that now :)"
. $HOME/.zshrc
exit 0
