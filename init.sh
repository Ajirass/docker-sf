#!/bin/bash

eval "$(docker-machine env dev)"

docker build -t robgd/ubuntu robgd/ubuntu
sh rebuild.sh