SHELL := /bin/bash

DOCKER_VERSION := $(shell docker --version 2>/dev/null)
DOCKER_COMPOSE_VERSION := $(shell docker-compose --version 2>/dev/null)

.PHONY: check-docker check-docker-compose check

check-docker:
ifdef DOCKER_VERSION
	@echo "using $(DOCKER_VERSION)"
else
	@echo "Docker is not installed"; exit 1
endif

check-docker-compose:
ifdef DOCKER_COMPOSE_VERSION
	@echo "using $(DOCKER_COMPOSE_VERSION)"
else
	@echo "Docker Compose is not installed"; exit 1
endif

check: check-docker check-docker-compose
