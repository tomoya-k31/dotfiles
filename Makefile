.PHONY: install install-deps init encrypt decrypt-secrets clean-decrypted

install-deps:
	@echo "=== Installing dependencies ==="
	brew install stow sheldon
	@echo "=== Creating XDG directories ==="
	mkdir -p $(HOME)/.config/ $(HOME)/.cache/ $(HOME)/.local/share/ $(HOME)/.local/state/

install:
	@echo "=== Installing dotfiles ==="
	stow -t ~ --no-folding zsh bash config aws

init: install-deps install
	@echo "=== Full installation completed ==="

install-check:
	@echo "=== Stow simulation ==="
	stow -t ~ -n --no-folding zsh bash config aws

encrypt-secrets:
	find secrets -name "*.local" -exec sops -e {} \; > {}.encrypted

decrypt-secrets:
	./scripts/decrypt-secrets.sh
