#!/bin/sh

set -o

export RAILS_ENV=production
export QUEUE=shrike
bundle exec rake resque:work
