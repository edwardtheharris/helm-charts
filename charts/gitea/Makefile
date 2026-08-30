SHELL := /usr/bin/env bash -O globstar

.PHONY: prepare-environment
prepare-environment:
	npm install

.PHONY: readme
readme: prepare-environment
	npm run readme:parameters
	npm run readme:lint

.PHONY: unittests
unittests: unittests-helm unittests-bash

.PHONY: unittests-helm
unittests-helm:
	helm unittest --strict -f 'unittests/helm/**/*.yaml' -f 'unittests/helm/values-conflicting-checks.yaml' ./

.PHONY: unittests-bash
unittests-bash:
	./unittests/bash/bats/bin/bats --pretty ./unittests/bash/tests/**/*.bats

.PHONY: update-helm-dependencies
update-helm-dependencies:
	helm dependency update

.PHONY: yamllint
yamllint:
	yamllint -c .yamllint .