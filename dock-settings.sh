. ./helpers.sh
inform "Setting dock shortcuts"
dockutil --remove all
dockutil --add '$HOME/Downloads' --view list --display folder
dockutil --add '$HOME/programming' --view list --display folder
dockutil --add '/Applications/Visual Studio Code.app'
dockutil --add '/Applications/iTerm.app'
dockutil --add '/Applications/Vivaldi.app'
dockutil --add '/Applications/Firefox Developer Edition.app'
dockutil --add '/Applications/Insomnia.app'
dockutil --add '/Applications/Slack.app'
dockutil --add '/Applications/Telegram Desktop.app'
dockutil --add '/Applications/TIDAL.app'
dockutil --add '/Applications/1Password 7.app'
dockutil --add '/Applications/zoom.us.app'
dockutil --add '/System/Applications/System Preferences.app'
