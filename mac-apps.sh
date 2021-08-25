. ./helpers.sh
# Mac apps
apps=(937984704 441258766 668208984 1153157709 409201541 497799835)
#      Magnet  Amphetamine  Giphy   Speedtest    Pages      XCode
warn "Please sign into the Mac store before continuing"
read -n 1 -r -s con
inform "Installing App Store applications" && mas install ${apps[@]}
