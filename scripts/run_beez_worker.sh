#!/bin/sh

set -o

export RAILS_ENV=production
export QUEUE=beezAttackQueue
bundle exec rake resque:work
