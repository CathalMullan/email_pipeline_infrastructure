.PHONY: hook
hook:
	pre-commit autoupdate
	pre-commit install

.PHONY: validate
validate:
	pre-commit run --all-files | tee logs/lint.log
