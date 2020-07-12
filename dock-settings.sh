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
dockutil --add '/Applications/Firefox Developer Edition.app'
dockutil --add '/Applications/Slack.app'
dockutil --add '/Applications/TIDAL.app'
dockutil --add '/Applications/1Password 7.app'
dockutil --add '/System/Applications/System Preferences.app'
if [[ $PERSONAL == y ]]; then
	inform "Adding personal shortcuts"
	dockutil --add '/Applications/Telegram Desktop.app' --after Slack
	dockutil --add '/Applications/Steam.app' --after "1Password 7"
	dockutil --add '/Applications/Discord.app' --after Steam
fi
