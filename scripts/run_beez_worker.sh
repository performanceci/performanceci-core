#!/bin/sh

set -e

export RAILS_ENV=production
export QUEUE=beezAttackQueue
bundle exec rake resque:work
