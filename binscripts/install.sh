#!/bin/bash

# exit on error
set -e

# logging functions
log() { printf "%b\n" "$*"; }
debug() { [[ ${PKS_DEBUG} != "true" ]] || printf "%b\n" "$*" >&2; }
fail() { log "\nERROR: $*\n" >&2 ; exit 1 ; }

pks_check_dependencies()
{
  debug "\nChecking dependencies...\n"

  which curl >/dev/null 2>&1 || fail "Could not find 'curl' command, make sure it's available first before continuing installation."
  which git >/dev/null 2>&1 || fail "Could not find 'git' command, make sure it's available first before continuing installation."
  which docker >/dev/null 2>&1 || fail "Could not find 'docker' command, make sure it's available first before continuing installation."
  which docker-compose >/dev/null 2>&1 || fail "Could not find 'docker-compose' command, make sure it's available first before continuing installation."
}

pks_parse_params()
{
  if [ "$#" -eq 0 ]; then
    set -- demo develop ./pks-deployment
  fi
  PKS_FLAVOR=$1
  PKS_BRANCH=$2
  PKS_DIR=$3

  debug "Flavor: '$PKS_FLAVOR'"
  debug "Branch: '$PKS_BRANCH'"
  debug "Directory: '$PKS_DIR'"
}

pks_download_repo()
{
  if [ ! -d "$PKS_DIR" ]; then
    log "\nCloning deployment scripts into '$PKS_DIR'...\n"

    git clone https://github.com/PrivateKeySpace/deployment $PKS_DIR
  else
    log "\nFound '$PKS_DIR', proceeding..."
  fi
}

pks_build_images()
{
  log "\nBuilding '$PKS_FLAVOR' Docker images for branch '$PKS_BRANCH'...\n"

  cd $PKS_DIR
  FLAVOR=$PKS_FLAVOR BRANCH=$PKS_BRANCH make build
  cd -
}

pks_run_containers ()
{
  log "\nRunning '$PKS_FLAVOR' Docker images...\n"

  cd $PKS_DIR
  FLAVOR=$PKS_FLAVOR make run
  cd -
}

# entry point function
pks_install()
{
  pks_check_dependencies
  pks_parse_params "$@"
  pks_download_repo
  pks_build_images
  pks_run_containers
}

pks_install "$@"
