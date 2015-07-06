#!/bin/sh

set -e

export DB_HOST='192.168.69.20'
export REDIS_HOST='192.168.69.20'
export RAILS_ENV=development
export QUEUE=beezAttackQueue
bundle exec rake resque:work
