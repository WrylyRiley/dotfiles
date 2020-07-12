#!/usr/bin/env bash
. helpers.sh

######################################################################
# Adding only the shortcuts I want to the dock
######################################################################
dockutil --remove all
dockutil --add '~/Downloads' --view grid --display folder
dockutil --add '~/programming' --view grid --display folder
dockutil --add '/Applications/Visual Studio Code.app'
dockutil --add '/Applications/iTerm.app'
dockutil --add '/Applications/Postman.app'
dockutil --add '/Applications/Vivaldi.app'
dockutil --add '/Applications/Slack.app'
dockutil --add '/Applications/TIDAL.app'
dockutil --add '/System/Applications/System Preferences.app'
if [[ $PERSONAL == y ]]; then
	inform " Adding personal shortcuts"
	dockutil --add '/Applications/Telegram.app' --after Slack
	dockutil --add '/Applications/Steam.app'
fi
