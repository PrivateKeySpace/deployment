SHELL := /bin/bash

DOCKER_VERSION := $(shell docker --version 2>/dev/null)
DOCKER_COMPOSE_VERSION := $(shell docker-compose --version 2>/dev/null)
CODE_ROOT_DIR := $(shell dirname "$$PWD")

.PHONY: check-docker check-docker-compose check-code check-flavor check-all build run

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
	@if [ ! -d "$(CODE_ROOT_DIR)/core" ] ; then echo "PKS 'core' code is missing at path $(CODE_ROOT_DIR)/core" ; exit 1 ; fi
	@if [ ! -d "$(CODE_ROOT_DIR)/web" ] ; then echo "PKS 'web' code is missing at path $(CODE_ROOT_DIR)/web" ; exit 1 ; fi

check-flavor:
ifndef FLAVOR
	@echo "flavor is not defined" ; exit 1
endif

check-all: check-docker check-docker-compose check-code check-flavor

build: check-all
	rm -rf ./config/core/code ; git clone $(CODE_ROOT_DIR)/core ./config/core/code
	rm -rf ./config/web/code ; git clone $(CODE_ROOT_DIR)/web ./config/web/code
	docker-compose --file ./config/docker-compose.$(FLAVOR).yml build

#run: check-docker check-docker-compose check-flavor
#	cd ./flavors/$(FLAVOR) ; docker-compose up
