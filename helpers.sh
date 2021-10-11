# Terminal colors
C="\033[1;32m"
R="\033[0m"

# Helper Functions
warn() { printf "\x1b[1;34m🟡 $1\x1b[0m\n"; }
error() { printf "\x1b[1;31m🔴 $1\x1b[0m\n"; }
inform() { printf "\x1b[1;32m🟢 $1\x1b[0m\n"; }
install_homebrew() {
    { which brew &>/dev/null && warn "Homebrew already installed..."; } || {
        inform "Installing homebrew"
        echo | /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        if [ $? -eq 0 ]; then inform 'Install successful'; else error "Install failed"; fi
    }
}
