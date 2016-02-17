#!/bin/bash

eval "$(docker-machine env dev)"

docker build -t robgd/ubuntu custom-ubuntu
sh rebuild.sh