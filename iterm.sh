#!/usr/bin/env bash
source helpers.sh

######################################################################
# iTerm2 Preferences
######################################################################
plist_dir="$HOME/Library/Application Support/iTerm2/DynamicProfiles"
if [[ ! -d $plist_dir ]]; then
	mkdir $plist_dir
fi
iterm_plist="$plist_dir/profiles.plist"
cp "./config/itermProfiles.json" $iterm_plist
inform "Make sure you change your default profile in iTerm"