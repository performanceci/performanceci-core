#!/bin/sh

set -o

apt-get update
apt-get upgrade -y
apt-get install -y git-core build-essential ruby2.0 ruby2.0-dev libsqlite3-dev bundler redis-server
