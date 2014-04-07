#!/bin/sh

set -e

export HOST=localhost
export RAILS_ENV=development
export QUEUE=docker
bundle exec rake resque:work
