######################################################################
# Adding only the shortcuts I want to the dock
######################################################################

dockutil --remove all
dockutil --add '~/Downloads'
dockutil --add '~/programming'
dockutil --add '/Applications/Vivaldi.app'
dockutil --add '/Applications/iTerm.app'
dockutil --add '/Applications/Slack.app'
dockutil --add '/Applications/Spotify.app'
dockutil --add '/Applications/TIDAL.app'
dockutil --add '/Applications/Postman.app'
dockutil --add '/Applications/Visual Studio Code.app'
dockutil --add '/System/Applications/System Preferences.app'
if [[ $PERSONAL == y ]]; then
	inform " Adding personal shortcuts"
	dockutil --add '/Applications/Telegram.app'
	dockutil --add '/Applications/Steam.app'
fi
