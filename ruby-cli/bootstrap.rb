#!/usr/bin/env ruby

require 'io/console'
require 'fileutils'

# Colorizers
class String
def info;     "\x1b[1;32m🟢 #{self}\x1b[0m\n" end
def warn;     "\x1b[1;34m🟡 #{self}\x1b[0m\n" end
def err;      "\x1b[1;31m🔴 #{self}\x1b[0m\n" end
def exp;      "#{File.expand_path(self)}"     end
end

#  Helpers
def checkDir(directory)
  return Dir.exists? directory.exp
end

def checkFile(file)
  return File.exists? file.exp
end

# meat of the code!

#####################################################################
####   Terminal developer tools   ###################################
#####################################################################
if `xcode-select -p 1>/dev/null;echo $?` == "0"
  puts "xcode-select not installed. Installing now".info
  `sudo xcode-select --install`
  # `sudo xcode-select -s /Applications/Xcode.app/Contents/Developer`
  # `sudo xcodebuild -license accept`
else
  puts "xcode-select already installed. Skipping installation".warn
  dfhkasjkghshfgfldkgsdfw
  jhgkjasdfkjghsjdfhgdsfw
end

#####################################################################
####   Homebrew   ###################################################
#####################################################################
brew_exists = checkFile("/usr/local/bin/brew")
if brew_exists
  puts "Homebrew already installed".warn
else
  # puts "Installing homebrew"
  # `echo | NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`
end

#####################################################################
####   Brew bundle install   ########################################
#####################################################################
puts "Please sign into the Mac store before continuing. Press return to continue".warn
STDIN.getch
puts "Running brew bundle".info
`brew bundle install`

#####################################################################
####   SSH agent, SSH key, GPG key   ################################
#####################################################################
FileUtils.mkdir_p '~/.ssh'.exp
puts "Would you like to restore your SSH key? Please ensure all files are in ~/.ssh (y/n)".info
input = STDIN.getch
if ['y', 'Y', 'yes'].include? input
  puts "Adding key to ssh-agent".info
  `eval "$(ssh-agent -s)"`
  FileUtils.touch "~/.ssh/config".exp
  FileUtils.chmod "0400", "~/.ssh/id_ed25519.pub".exp
  FileUtils.chmod "0400", "~/.ssh/id_ed25519".exp
  File.write("~/.ssh.config".exp , "Host *
    AddKeysToAgent yes
    UseKeychain yes
    IdentityFile ~/.ssh/id_ed25519
    ")
else
  
end





