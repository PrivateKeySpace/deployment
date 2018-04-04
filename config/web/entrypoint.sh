#!/bin/bash

# exit on error
set -e

# start proxy server
service nginx start

# persist
while true; do sleep 1d; done
