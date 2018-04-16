#!/usr/bin/env bash
set -e

PKS_DEBUG="0"
PKS_DIR="$PWD"
PKS_VERSION="develop"
PKS_FLAVOR="regtest"

function log () { printf "%b\n" "$*"; }
function debug () { [[ "$PKS_DEBUG" != "1" ]] || printf "%b\n" "$*" >&2 ; }
function fail () { log "\nERROR: $*\n" >&2 ; exit 1 ; }

function checkDependencies () {
  log "Checking dependencies..."

  which curl >/dev/null 2>&1 || fail "Could not find 'curl' command, make sure it's available first before continuing installation."
  which docker >/dev/null 2>&1 || fail "Could not find 'docker' command, make sure it's available first before continuing installation."
  which docker-compose >/dev/null 2>&1 || fail "Could not find 'docker-compose' command, make sure it's available first before continuing installation."

  log "Done."
  log ""

  log "Using $(docker --version)"
  log "Using $(docker-compose --version)"
  log ""
}

function readArgument_PKS_FLAVOR () {
  PKS_FLAVOR="$2"

  if [ "$PKS_FLAVOR" == "" ]; then
    fail "Must specify flavor as a script argument."
  fi
}

function ensureWorkDir () {
  if [ ! -d "$PKS_DIR" ]; then
    log "Directory '$PKS_DIR' not found, creating directory..."

    mkdir -p "$PKS_DIR"

    log "Done."
    log ""
  fi

  log "Running in '$PKS_DIR'."
  log ""
}

function ensureDockerComposeFiles () {
  log "Searching for '$PKS_VERSION-$PKS_FLAVOR' Docker Compose files in '$PKS_DIR'..."

  __config_file_1_path="$PKS_DIR/docker-compose.$PKS_FLAVOR.yml"
  __config_file_2_path="$PKS_DIR/docker-compose.$PKS_FLAVOR.run.yml"

  if [ -f "$__config_file_1_path" -a -f "$__config_file_2_path" ]; then
    log "Found."
    log ""
    return
  fi

  log "Not found."
  log ""

  log "Downloading '$PKS_VERSION-$PKS_FLAVOR' Docker Compose files into '$PKS_DIR'..."

  __config_file_1_url="https://github.com/PrivateKeySpace/deployment/raw/$PKS_VERSION/config/docker-compose.$PKS_FLAVOR.yml"
  __config_file_2_url="https://github.com/PrivateKeySpace/deployment/raw/$PKS_VERSION/config/docker-compose.$PKS_FLAVOR.run.yml"

  curl -fsSL -o "$__config_file_1_path" "$__config_file_1_url" || fail "Failed to download '$__config_file_1_url'."
  curl -fsSL -o "$__config_file_2_path" "$__config_file_2_url" || fail "Failed to download '$__config_file_2_url'."

  log "Done."
  log ""
}

function dockerComposePull () {
  log "Pulling '$PKS_VERSION-$PKS_FLAVOR' images from Docker Hub..."

  __config_file_path="$PKS_DIR/docker-compose.$PKS_FLAVOR.yml"

  docker-compose --file "$__config_file_path" pull

  log "Done."
  log ""
}

function dockerComposeUp () {
  log "Running '$PKS_VERSION-$PKS_FLAVOR' containers..."

  __config_file_1_path="$PKS_DIR/docker-compose.$PKS_FLAVOR.yml"
  __config_file_2_path="$PKS_DIR/docker-compose.$PKS_FLAVOR.run.yml"

  docker-compose --file "$__config_file_1_path" --file "$__config_file_2_path" up --detach

  log "Done."
  log ""
}

function dockerComposeDown () {
  log "Stopping '$PKS_VERSION-$PKS_FLAVOR' containers..."

  __config_file_1_path="$PKS_DIR/docker-compose.$PKS_FLAVOR.yml"
  __config_file_2_path="$PKS_DIR/docker-compose.$PKS_FLAVOR.run.yml"

  docker-compose --file "$__config_file_1_path" --file "$__config_file_2_path" down

  log "Done."
  log ""
}

function handleCommand_install () {
  dockerComposePull
}

function handleCommand_start () {
  dockerComposeUp
}

function handleCommand_stop () {
  dockerComposeDown
}

function run () {
  log ""

  checkDependencies
  readArgument_PKS_FLAVOR "$@"
  ensureDockerComposeFiles

  __command="$1"

  if [ "$__command" == "install" ]
  then
      handleCommand_install
  elif [ "$__command" == "start" ]
  then
      handleCommand_start
  elif [ "$__command" == "stop" ]
  then
      handleCommand_stop
  else
      fail "Command '$__command' not supported."
  fi

  log "Finished."
  log ""
}

run "$@"
