#!/bin/sh

set -e

export DB_HOST='192.168.69.20'
export REDIS_HOST='192.168.69.20'
export DOCKER_HOST='192.168.69.30'
export RAILS_ENV=development
export QUEUE=docker
nohup bundle exec rake resque:work 2>&1 < /dev/null >> ~/.docker.out &
