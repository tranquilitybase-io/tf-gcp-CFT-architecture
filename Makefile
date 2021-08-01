# Use bash instead of sh
SHELL := /usr/bin/env bash

.PHONY: bootstrap
bootstrap:
	@source scripts/0-bootstrap/bootstrap.sh

.PHONY: org
org:
	@source scripts/1-org/org.sh

.PHONY: env
env:
	@source scripts/2-environments/environments.sh
