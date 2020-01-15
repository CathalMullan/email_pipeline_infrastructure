.PHONY: hook
hook:
	pre-commit autoupdate
	pre-commit install

.PHONY: lint
lint:
	pre-commit run --all-files

.PHONY: validate
validate:
	make lint
