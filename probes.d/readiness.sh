#!/bin/bash

test `riak ping` == "pong"
test `cat "/etc/riak/readiness.txt"` == "ready"
