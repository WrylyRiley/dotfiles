#!/bin/zsh

##################################
# Setup                          #
##################################
export BOOTSTRAP_ROOT="$(cd "$(dirname "$0")" && pwd)"
. ./common/utils.sh
pi=false
mac=false
wsl=false

usage() {
  cat <<EOF
usage: $0 

This script runs a general dotfiles setup.
It will change as little as posible depending on existing system configuration

OPTIONS:
    [-p personal] Sets personal options to install like Steam and personal github settings
    [-m Mac OS] Installs for macOS. Cannot be uses with -w or -p
    [-w WSL] Installs for WSL. Cannot be uses with -m or -p
    [-r Raspberry Pi] Install for Headless Raspberry Pi. Cannot be uses with -w or -m
    [-h Help]  Show this message
EOF
}

while getopts “h:wmp” OPTION; do
  case $OPTION in
  h)
    usage
    exit 1
    ;;
  w)
    wsl=true
    ;;
  m)
    mac=true
    ;;
  p)
    pi=true
    ;;
  ?)
    usage
    exit
    ;;
  esac
done

# Enforce rules about option combos
if $mac && $pi || $mac && $wsl || $pi && $wsl; then
  echo "$0: You can only specify one environment at a time." >&2
  exit 1
fi

if $mac; then
  sh ./macOS/bootstrap.sh
  exit 0
fi

if $wsl; then
  sh ./wsl/bootstrap.sh
  exit 0
fi

if $pi; then
  # $1 = ip address of pi

  cat $HOME/.ssh/id_ed25519.pub | ssh pi@$1 "mkdir -p $HOME/.ssh && cat >> $HOME/.ssh/authorized_keys"
  scp -r ./raspberry_pi pi@$1:/tmp
  ssh pi@$1 'cd /tmp/raspberry_pi; chmod +x ./pi_headless.sh; . ./pi_headless.sh'

  sh ./raspberry_pi/bootstrap.sh
  exit 0
fi

error "You must specify a build environment tp use this script"
exit 1
