#!/bin/bash

# exit on error
set -e

# start proxy server
service nginx start

# start application server
pm2-runtime ./process.json --raw
