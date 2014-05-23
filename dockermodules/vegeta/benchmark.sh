#!/bin/bash
#set -x

if [ "$1" == 'container' ]; then
  ENDPOINT="$(echo $TEST_HOST_PORT | sed 's/tcp/http/')$2"
else
  ENDPOINT="$2"
fi
#echo "GET $ENDPOINT | /opt/goroot/bin/vegeta attack -duration=$4 -rate=$3 | tee results.bin | /opt/goroot/bin/vegeta report -reporter=json"

RESULT=$(echo "GET $ENDPOINT" | /opt/goroot/bin/vegeta attack -duration=$4 -rate=$3 | /opt/goroot/bin/vegeta report -reporter=json)
echo $RESULT