. ./helpers.sh
# iTerm2 Preferences
plistdir=~/Library/Application\ Support/iTerm2/DynamicProfiles
[[ ! -d $plistdir ]] && mkdir -p $plistdir
inform "Setting iTerm preferences"
cp -f "./config/itermProfiles.json" "${plistdir}/profiles.plist"
warn "Make sure you change your default profile in iTerm"
