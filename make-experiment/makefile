# Colors
C = "\033[1;32m"
R = "\033[0m"
personal = false
THIS_FILE := $(lastword $(MAKEFILE_LIST))

# Helpers
define error
 @echo "\x1b[1;31m🔴$(1)\x1b[0m\n"
endef

define warn
 @echo "\x1b[1;34m🟡$(1)\x1b[0m"
endef

define inform
 @echo "\x1b[1;32m🟢$(1)\x1b[0m\n"
endef



# Targets

test: 
	personal = true
	$(MAKE) -f $(THIS_FILE) bs

bs: 
	@echo "$(personal)"

testbiz:
	@echo "$(personal)"

# bootstrap:
#  mkdir -p "~/programming"
#  mkdir -p "~/.ssh"
#  $(call inform,"Before, starting, please make sure of the following")
#  $(call inform,"Place your RSA keys in ~/.ssh")
#  $(call inform,"Sign into the Mac app store")


# dock:
# 	$(call inform,"Setting dock shortcuts")
# 	dockutil --remove all
# 	dockutil --add '~/Downloads' --view list --display folder
# 	dockutil --add '~/programming' --view list --display folder
# 	dockutil --add '~/code' --view list --display folder
# 	dockutil --add '/Applications/Visual Studio Code.app'
# 	dockutil --add '/Applications/iTerm.app'
# 	dockutil --add '/Applications/Vivaldi.app'
# 	dockutil --add '/Applications/Firefox Developer Edition.app'
# 	dockutil --add '/Applications/Insomnia.app'
# 	dockutil --add '/Applications/Slack.app'
# 	dockutil --add '/Applications/Telegram Desktop.app'
# 	dockutil --add '/Applications/TIDAL.app'
# 	dockutil --add '/Applications/1Password 7.app'
# 	dockutil --add '/Applications/zoom.us.app'
# 	dockutil --add '/System/Applications/System Preferences.app'
# 	ifeq ($(PERSONAL),y)

# 	endif

.DEFAULT: bootstrap

