trackpadSettings=("showLaunchpadGestureEnabled -int 0" "ActuateDetents -int 1"
  "Clicking -int 0" "DragLock -int 0" "Dragging -int 0" "FirstClickThreshold -int 1"
  "ForceSuppressed -int 0" "SecondClickThreshold -int 1" "TrackpadCornerSecondaryClick -int 0"
  "TrackpadFiveFingerPinchGesture -int 2" "TrackpadFourFingerHorizSwipeGesture -int 2"
  "TrackpadFourFingerPinchGesture -int 2" "TrackpadFourFingerVertSwipeGesture -int 2"
  "TrackpadHandResting -int 1" "TrackpadHorizScroll -int 1" "TrackpadMomentumScroll -int 1"
  "TrackpadPinch -int 1" "TrackpadRightClick -int 1" "TrackpadRotate -int 1" "TrackpadScroll -int 1"
  "TrackpadThreeFingerDrag -int 0" "TrackpadThreeFingerHorizSwipeGesture -int 2"
  "TrackpadThreeFingerTapGesture -int 2" "TrackpadThreeFingerVertSwipeGesture -int 2"
  "TrackpadTwoFingerDoubleTapGesture -int 1" "TrackpadTwoFingerFromRightEdgeSwipeGesture -int 0"
  "USBMouseStopsTrackpad -int 0")

updateDefaultsSetting() {
  local property=$(echo ${1} | sed 's/ .*//')
  local result=$(defaults read ${2} $property)
  if echo $1 | grep -qoE ".*$result$"; then
    echo "${property} already set"
  else
    echo "writing new setting"
    $(defaults write ${2} ${action} &>/dev/null &)
  fi
}

# for action in "${trackpadSettings[@]}"; do
#   updateDefaultsSetting "${action}" "com.apple.AppleMultitouchTrackpad"
# done
domain="\"NSStatusItem Visible Item-0\""
updateDefaultsSetting "${domain} -int 0" "com.apple.Spotlight"
