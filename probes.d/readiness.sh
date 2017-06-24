#!/bin/bash

CLUSTER_STATUS=/etc/riak/cluster-status.txt

test `riak ping` == "pong"
test `cat "$CLUSTER_STATUS"` == "ready"
