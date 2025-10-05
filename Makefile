.PHONY: install install-deps init install-check encrypt decrypt sync vscode-setup

install-deps:
	@echo "=== Installing dependencies ==="
	brew install stow sheldon
	@echo "=== Creating XDG directories ==="
	mkdir -p $(HOME)/.config/ $(HOME)/.cache/ $(HOME)/.local/share/ $(HOME)/.local/state/

install:
	@echo "=== Installing dotfiles ==="
	stow -t ~ --no-folding zsh bash config

init: install-deps install vscode-setup
	@echo "=== Full installation completed ==="

install-check:
	@echo "=== Stow simulation ==="
	stow -t ~ -n --no-folding zsh bash config

vscode-setup:
	@echo "Setting up VS Code with XDG..."
ifeq ($(shell uname), Darwin)
	ln -sf ~/.config/vscode/User/settings.json ~/Library/Application\ Support/Code/User/settings.json
endif
	@echo "Done!"

encrypt:
	./scripts/encrypt-files.sh

decrypt:
	./scripts/decrypt-files.sh

sync:
	@echo "=== Updating gitignore file ==="
	./scripts/update-gitignore.sh
	@echo "=== Syncing files ==="
	./scripts/sync.sh
