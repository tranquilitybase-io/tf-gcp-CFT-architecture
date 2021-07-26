# Use bash instead of sh
SHELL := /usr/bin/env bash

.PHONY: bootstrap
bootstrap:
	@source scripts/bootstrap/bootstrap.sh

.PHONY: org
org:
	@source scripts/org/org.sh
