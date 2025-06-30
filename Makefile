.PHONY: install encrypt decrypt-secrets clean-decrypted

install:
	@echo "=== Decrypting encrypted files ==="
	@echo "=== Installing dotfiles ==="
	stow -t ~ --no-folding zsh bash config aws

ln-check:
	@echo "=== Stow simulation ==="
	stow -t ~ -n --no-folding zsh bash config aws

encrypt-secrets:
	find secrets -name "*.local" -exec sops -e {} \; > {}.encrypted

decrypt-secrets:
	./scripts/decrypt-secrets.sh
