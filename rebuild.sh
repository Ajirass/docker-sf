#!/bin/bash

eval "$(docker-machine env dev)"

docker-compose stop
docker-compose rm -f
docker-compose up -d
