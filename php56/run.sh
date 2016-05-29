#!/usr/bin/env bash

chown -R docker:docker /opt/robgd

service php5-fpm start

tail -f /dev/null