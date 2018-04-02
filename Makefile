SHELL := /bin/bash

DOCKER_VERSION := $(shell docker --version 2>/dev/null)
DOCKER_COMPOSE_VERSION := $(shell docker-compose --version 2>/dev/null)

.PHONY: check-docker check-docker-compose check-branch check-flavor check-all git-clone git-checkout install build

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

check-branch:
ifndef BRANCH
	@echo "branch is not defined" ; exit 1
endif

check-flavor:
ifndef FLAVOR
	@echo "flavor is not defined" ; exit 1
endif

check-all: check-docker check-docker-compose check-branch check-flavor

flavors/$(FLAVOR)/repos:
	mkdir ./flavors/$(FLAVOR)/repos
	cd ./flavors/$(FLAVOR)/repos ; git clone https://github.com/PrivateKeySpace/core.git
	cd ./flavors/$(FLAVOR)/repos ; git clone https://github.com/PrivateKeySpace/web.git

git-clone: flavors/$(FLAVOR)/repos

git-checkout:
	cd ./flavors/$(FLAVOR)/repos/core ; git checkout $(BRANCH) ; git pull origin $(BRANCH)
	cd ./flavors/$(FLAVOR)/repos/web ; git checkout $(BRANCH) ; git pull origin $(BRANCH)

install: git-clone git-checkout

build: check-all install
	cd ./flavors/$(FLAVOR) ; docker-compose build

run: check-docker check-docker-compose check-flavor
	cd ./flavors/$(FLAVOR) ; docker-compose up
