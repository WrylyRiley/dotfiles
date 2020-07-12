# dotfiles

## Various configuration files and scripts I use to bootstrap my Mac

### What is has
- installs homebrew
  - Installs casks and formulae I use frequently
- Assigns RSA keys to `ssh-agent`
  - They have to already be in `~/.ssh`
- Installs various Mac store apps I use
  - You have to be signed in already
- Installs iTerm2 preferences
- Updates git settings
- Adds shortcuts I use to the dock 
- Sets a handful of system preferences with `defaults`
- Installs global node modules
- Installs oh-my-zsh + preferences

### What it needs
- An automated system to grab my RSA keys from 1Password
  - This is unlikely since the 1password-cli requires a lot of user input to get going 
