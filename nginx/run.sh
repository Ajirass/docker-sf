#!/usr/bin/env bash

service nginx start
service php5-fpm start

tail -f /dev/null