#!/usr/bin/env bash

redis-server /etc/redis/redis.conf &

tail -f /dev/null