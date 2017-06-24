#!/bin/bash

set -ex

CLUSTER_STATUS=/etc/riak/cluster-status.txt

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

riak ping

echo "ready" > $CLUSTER_STATUS

tail -n 1024 -f /var/log/riak/console.log &
TAIL_PID=$!

function graceful_death {
  echo "dying" > $CLUSTER_STATUS

  if [ -n "$KUBERNETES_SERVICE_PORT" -a -n "$KUBERNETES_SERVICE_PORT" ]
  then
    riak-admin cluster leave
    riak-admin cluster plan
    riak-admin cluster commit

    while ! riak-admin transfers | grep -iqF 'No transfers active'
    do
      echo 'Transfers in progress'
      sleep 10
    done
  fi 

  kill $TAIL_PID
}

trap graceful_death SIGTERM SIGINT

wait $TAIL_PID
