#!/bin/bash

set -ex

if [ -n "$KUBERNETES_SERVICE_HOST" -a -n "$KUBERNETES_SERVICE_PORT" ]
then
  echo "Kubernetes service available at $KUBERNETES_SERVICE_HOST:$KUBERNETES_SERVICE_PORT"
  
  HOST_IP=`hostname -I | awk '{ print $1; }'`

  if [ -z "$RIAK_NODE_NAME" ]
  then
    RIAK_NODE_NAME=riak
  fi

  RIAK_KUBERNETES_NODES=`python /etc/riak/poststart.d/riak-discover.py "$HOST_IP"`

  CLUSTER_EXISTS=false

  for node in $RIAK_KUBERNETES_NODES; do
    if [ "$HOST_IP" != "$node" ]
    then
      if [ "$CLUSTER_EXISTS" != "true" ]
      then
        riak-admin cluster join "$RIAK_NODE_NAME@$node"
      fi

      CLUSTER_EXISTS=true
    fi
  done

  if [ "$CLUSTER_EXISTS" == "true" ]
  then
    riak-admin cluster plan
    riak-admin cluster commit

    while ! riak-admin transfers | grep -iqF 'No transfers active'
    do
      echo 'Transfers in progress'
      sleep 10
    done
  else
    echo "Node is first in cluster."
  fi
else
  echo "Kubernetes service not detected, will not autojoin cluster."
fi

riak-admin cluster status

echo "ready" > /etc/riak/cluster-status.txt
