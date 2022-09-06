# dotfiles

## Various configuration files and scripts I use to bootstrap my Mac

### What is has
- Installs homebrew
  - Installs casks and formulae I use frequently
- Activates RSA keys with `ssh-agent`
  - They have to already be in `$HOME/.ssh`
- Restores gpg keys
  - They have to be in 
- Installs various Mac store apps I use
  - You have to be signed in already, which should be the case since the setup signs you in 
- Sets iTerm2 profile and (some) defaults
- Updates git config
- Adds shortcuts I use to the dock 
- Sets a LOT of system preferences with `defaults`
- Installs global node modules and fnm
- Installs zsh config

### What it needs
- An automated system to grab my RSA keys from 1Password
  - This is unlikely since the 1password-cli requires a lot of user input to get going and doesn't automatically sign in the desktop client
- Added automation to set up GPG signing in git

## Linux

Make sure you have your keys in place, then run the pi bootstrap script
