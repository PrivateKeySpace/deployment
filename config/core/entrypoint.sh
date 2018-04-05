#!/bin/bash

# exit on error
set -e

# migrate database
if [ ! -f ./.migrations_applied ]; then
  cd ./core
  make migratedb-up
  cd ..
  echo "1" >> ./.migrations_applied
fi

# start proxy server
service nginx start

# start application server
pm2-runtime ./process.json --raw
