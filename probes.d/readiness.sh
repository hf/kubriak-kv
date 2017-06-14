#!/bin/bash

test `riak ping` == "pong"
test `cat /etc/riak/cluster-status.txt` == "ready"
