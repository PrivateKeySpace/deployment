#!/bin/bash

# exit on error
set -e

# logging functions
log() { printf "%b\n" "$*"; }
debug() { [[ ${PKS_DEBUG} != "1" ]] || printf "%b\n" "$*" >&2; }
fail() { log "\nERROR: $*\n" >&2 ; exit 1 ; }

pks_check_dependencies()
{
  debug "\nChecking dependencies...\n"

  which curl >/dev/null 2>&1 || fail "Could not find 'curl' command, make sure it's available first before continuing installation."
  which docker >/dev/null 2>&1 || fail "Could not find 'docker' command, make sure it's available first before continuing installation."
  which docker-compose >/dev/null 2>&1 || fail "Could not find 'docker-compose' command, make sure it's available first before continuing installation."
}

pks_parse_params()
{
  PKS_VERSION=${1:-"develop"}
  PKS_FLAVOR=${2:-"regtest"}
  PKS_DIR=${3:-"~/.pkswallet/config"}

  debug "Version: '$PKS_VERSION'"
  debug "Flavor: '$PKS_FLAVOR'"
  debug "Directory: '$PKS_DIR'"
}

pks_download_config()
{
  log "\nDownloading config into '$PKS_DIR'...\n"

  if [ ! -d "$PKS_DIR" ]; then
    mkdir -p "$PKS_DIR"
  fi

  curl -sSL "https://github.com/PrivateKeySpace/deployment/raw/$PKS_VERSION/config/docker-compose.$PKS_FLAVOR.yml" > "$PKS_DIR/docker-compose.$PKS_FLAVOR.yml"
}

pks_pull_images()
{
  log "\nPulling '$PKS_VERSION-$PKS_FLAVOR' images from Docker Hub...\n"

  docker-compose --file "$PKS_DIR/docker-compose.$PKS_FLAVOR.yml" pull
}

pks_run_containers ()
{
  log "\nRunning '$PKS_VERSION-$PKS_FLAVOR' containers...\n"

  docker-compose --file "$PKS_DIR/docker-compose.$PKS_FLAVOR.yml" up
}

# entry point function
pks_run()
{
  pks_check_dependencies
  pks_parse_params "$@"
  pks_download_config
  pks_pull_images
  pks_run_containers
}

pks_run "$@"
