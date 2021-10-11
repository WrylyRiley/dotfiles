. ./helpers.sh
# iTerm2 Preferences
plistdir=$HOME/Library/Application\ Support/iTerm2/DynamicProfiles
mkdir -p $plistdir
inform "Setting iTerm preferences"
cp -f "./config/itermProfiles.json" "${plistdir}/profiles.plist"
warn "Make sure you change your default profile in iTerm"
