#!/bin/bash

# exit on error
set -e

# migrate database
cd ./core
make migratedb-up
cd -

# start proxy server
service nginx start

# start application server
pm2-runtime ./process.json --raw
