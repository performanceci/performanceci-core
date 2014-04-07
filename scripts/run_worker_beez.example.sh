#!/bin/sh

set -e

export RAILS_ENV=development
export QUEUE=beezAttackQueue
bundle exec rake resque:work
