# dotfiles

## Various configuration files and scripts I use to bootstrap my Mac

### What is has
- Installs homebrew
  - Installs casks and formulae I use frequently
- Activates RSA keys with `ssh-agent`
  - They have to already be in your user home directory
- Restores gpg keys
  - They also have to be in your user home directory
- Installs various Mac store apps I use
  - You have to be signed in already, which should be the case since the setup signs you in.
  - FOr me, in case it isn't the case, I make sure to instlal 1Password early so I can grab my credentials
- Sets iTerm2 profile and (some) defaults
- Updates git config
- Adds shortcuts I use to the dock with `dockutil`
- Sets a LOT of system preferences with `defaults`
- Installs global node modules and asdf
- Installs zsh config, plugins, and common aliases

### What it needs
- An automated system to grab my RSA keys from 1Password
  - This is unlikely since the 1password-cli requires a lot of user input to get going and doesn't automatically sign in the desktop client
- Added automation to set up GPG signing in git

## Linux

Make sure you have your keys in place, then run the pi bootstrap script
