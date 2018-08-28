#!/usr/bin/env bash

set -euo pipefail

# TODO: Detect what DB, etc. initializing we should do and do it

echo "Starting Rails server"

bundle exec rails server
