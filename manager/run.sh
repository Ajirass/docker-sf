#!/usr/bin/env bash

redis-commander --redis-host redis &

tail -f /dev/null