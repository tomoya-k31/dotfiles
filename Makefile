.PHONY: install install-deps init encrypt decrypt-secrets clean-decrypted template-to-encrypted encrypted-to-template source-to-template template-to-source check-files detect-local-changes detect-remote-changes check-sync-status update-sync-state sync-local-to-remote sync-remote-to-local auto-sync backup restore cleanup-backups

install-deps:
	@echo "=== Installing dependencies ==="
	brew install stow sheldon
	@echo "=== Creating XDG directories ==="
	mkdir -p $(HOME)/.config/ $(HOME)/.cache/ $(HOME)/.local/share/ $(HOME)/.local/state/

install:
	@echo "=== Installing dotfiles ==="
	stow -t ~ --no-folding zsh bash config

init: install-deps install
	@echo "=== Full installation completed ==="

install-check:
	@echo "=== Stow simulation ==="
	stow -t ~ -n --no-folding zsh bash config

encrypt:
	./scripts/encrypt-files.sh

decrypt:
	./scripts/decrypt-files.sh

sync:
	@echo "=== Syncing files ==="
	./scripts/update-gitignore.sh
	./scripts/sync.sh
