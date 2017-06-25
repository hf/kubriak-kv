#!/bin/bash

set -ex

if iskube.sh
then
  riak-admin cluster status
  riak-admin cluster leave
  riak-admin cluster plan
  riak-admin cluster commit

  while riak ping
  do
    echo "Transfers in progress..."
    sleep 10
  done
else
  riak stop

  while riak ping
  do
    echo "Stopping..."
    sleep 5
  done
fi

echo "dead" > /etc/riak/readiness.txt
