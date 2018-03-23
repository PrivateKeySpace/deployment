SHELL := /bin/bash

DOCKER_VERSION := $(shell docker --version 2>/dev/null)
DOCKER_COMPOSE_VERSION := $(shell docker-compose --version 2>/dev/null)

.PHONY: check-docker check-docker-compose check-all git-clone git-checkout install

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

check-all: check-docker check-docker-compose

.repos:
	mkdir ./.repos

.repos/core:
	cd ./.repos ; git clone https://github.com/PrivateKeySpace/core.git

.repos/web:
	cd ./.repos ; git clone https://github.com/PrivateKeySpace/web.git

git-clone: .repos .repos/core .repos/web

git-checkout:
ifndef BRANCH
	@echo "branch is not defined" ; exit 1
endif
	cd ./.repos/core ; git checkout $(BRANCH) ; git pull origin $(BRANCH)
	cd ./.repos/web ; git checkout $(BRANCH) ; git pull origin $(BRANCH)

install: git-clone git-checkout
