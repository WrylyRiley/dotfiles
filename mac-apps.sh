#!/usr/bin/env bash
. helpers.sh

######################################################################
# Mac apps
######################################################################
apps=(
    937984704  # Magnet
    441258766  # Amphetamine
    668208984  # Giphy
    1153157709 # Speedtest by Ookla
    409201541  # Pages
    497799835  # XCode
)
warn "Please sign into the Mac store before continuing"
read -n 1 -r -s CON
for i in "${apps[@]}"; do mas install "$i"; done
