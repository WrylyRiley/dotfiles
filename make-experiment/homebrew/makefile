BREW = /usr/local/bin/brew
DOCKER = /Applications/Docker.app

export NVM = $(shell brew --prefix nvm)

$(BREW):
	@echo "${LOG_PREFIX} installing homebrew"
	@/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

install: $(BREW)
	@brew bundle install --no-lock
	@source $(NVM)/nvm.sh && nvm install 14
	@source $(NVM)/nvm.sh && nvm use 14
	
personal: $(PERSONAL)
	ifeq ($(PERSONAL),y)
		@brew bundle install -f ./personal/brewfile --no-lock
	endif
	

.PHONY install
.DEFAULT install personal