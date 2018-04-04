#!/bin/bash

# exit on error
set -e

# inject env variables in build
rm -rf ./web/build
cp -r ./web/build_clean ./web/build
replace-in-file REACT_APP_API_BASE_URL_PLACEHOLDER $(printenv PKS_API_BASE_URL) ./build/**/*.js,./build/**/*.html
chown -R www-data:www-data ./web/build

# start proxy server
service nginx start

# persist
while true; do sleep 1d; done
