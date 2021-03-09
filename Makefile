default: help

.PHONY: dotfiles
dotfiles: ## Create/remove symlinks in/from folder [$HOME/.dotfiles]
	-@$(CURDIR)/dotfiles/_before/before.sh
	-@$(CURDIR)/dotfiles/dotfiles.sh
	-@$(CURDIR)/dotfiles/_after/after.sh

.PHONY: brew
brew: ## Installs commonly used Homebrew packages and casks
	-@$(CURDIR)/brew/_before/before.sh
	-@$(CURDIR)/brew/brew.sh
	-@$(CURDIR)/brew/_after/after.sh

.PHONY: mac
mac: ## Install macOS KeyBindings, setup finder customizations and keyboard preferences
	-@$(CURDIR)/mac/_before/before.sh
	-@$(CURDIR)/mac/mac-os.sh
	-@$(CURDIR)/mac/_after/after.sh

.PHONY: all
all: mac dotfiles brew  ## Execute `mac`, `dotfiles` and `brew` in this order

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'