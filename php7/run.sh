#!/usr/bin/env bash

chown -R docker:docker /opt/robgd

service php7.0-fpm start

tail -f /dev/null