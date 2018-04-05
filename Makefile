SHELL := /bin/bash

GIT_VERSION := $(shell git --version 2>/dev/null)
DOCKER_VERSION := $(shell docker --version 2>/dev/null)
DOCKER_COMPOSE_VERSION := $(shell docker-compose --version 2>/dev/null)
CODE_ROOT_DIR := $(shell dirname "$$PWD")

.PHONY: check-git check-docker check-docker-compose check-code check-flavor check-all build run

check-git:
ifdef GIT_VERSION
	@echo "using $(GIT_VERSION)"
else
	@echo "Git is not installed" ; exit 1
endif

check-docker:
ifdef DOCKER_VERSION
	@echo "using $(DOCKER_VERSION)"
else
	@echo "Docker is not installed" ; exit 1
endif

check-docker-compose:
ifdef DOCKER_COMPOSE_VERSION
	@echo "using $(DOCKER_COMPOSE_VERSION)"
else
	@echo "Docker Compose is not installed" ; exit 1
endif

check-code:
ifeq (,$(wildcard $(CODE_ROOT_DIR)/core))
	@echo "PKS 'core' code is missing at path $(CODE_ROOT_DIR)/core" ; exit 1
endif
ifeq (,$(wildcard $(CODE_ROOT_DIR)/web))
	@echo "PKS 'web' code is missing at path $(CODE_ROOT_DIR)/web" ; exit 1
endif

check-flavor:
ifndef FLAVOR
	@echo "FLAVOR is not defined" ; exit 1
endif
ifneq (,$(wildcard ./config/docker-compose.$(FLAVOR).yml))
	@echo "building a '$(FLAVOR)' flavor"
else
	@echo "specified FLAVOR is not supported" ; exit 1
endif

check-all: check-git check-docker check-docker-compose check-code check-flavor

build: check-all
	rm -rf ./config/core/code ; git clone $(CODE_ROOT_DIR)/core ./config/core/code
	rm -rf ./config/web/code ; git clone $(CODE_ROOT_DIR)/web ./config/web/code
	docker-compose --file ./config/docker-compose.$(FLAVOR).yml build

run: check-docker check-docker-compose check-flavor
	docker-compose --file ./config/docker-compose.$(FLAVOR).yml up
