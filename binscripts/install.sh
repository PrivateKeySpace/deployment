#!/bin/bash

# exit on error
set -e

# logging functions
log() { printf "%b\n" "$*"; }
debug() { [[ ${PKS_DEBUG} != "true" ]] || printf "%b\n" "$*" >&2; }
fail() { log "\nERROR: $*\n" >&2 ; exit 1 ; }

# entry point function
pks_install()
{
  log "normal msg"
  debug "debug msg"
}

pks_install "$@"
