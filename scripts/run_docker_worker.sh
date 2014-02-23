#!/bin/sh

set -e

export RAILS_ENV=production
export QUEUE=docker
bundle exec rake resque:work
