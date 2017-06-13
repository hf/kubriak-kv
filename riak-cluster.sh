#!/bin/bash

set -ex

PRESTART=$(find /etc/riak/prestart.d -name '*.sh' -print | sort)
POSTSTART=$(find /etc/riak/poststart.d -name '*.sh' -print | sort)

for s in $PRESTART; do
  . $s
done

cat /etc/riak/riak.conf

if [ -r "/etc/riak/advanced.conf" ]
then
  cat /etc/riak/advanced.conf
fi

riak chkconfig

riak start

riak-admin wait-for-service riak_kv

riak ping

riak-admin test

for s in $POSTSTART; do
  . $s
done

tail -n 1024 -f /var/log/riak/console.log &
TAIL_PID=$!

function graceful_death {
  if [ -n "$KUBERNETES_SERVICE_PORT" -a -n "$KUBERNETES_SERVICE_PORT" ]
  then
    riak-admin cluster leave

    while ! riak-admin transfers | grep -iqF 'No transfers active'
    do
      echo 'Transfers in progress'
      sleep 5
    done
  fi 

  kill $TAIL_PID
}

trap graceful_death SIGTERM SIGINT

wait $TAIL_PID
