#!/bin/bash

# exit on error
set -e

# start system services
service nginx start
service postgresql start

# start `core`
pm2-runtime ./process.json --raw
