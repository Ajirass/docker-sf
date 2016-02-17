#!/usr/bin/env bash

docker-machine stop dev
docker-machine rm dev
docker-machine create --driver virtualbox \
    --virtualbox-cpu-count "2" \
    --virtualbox-memory "2048" \
    --virtualbox-disk-size "20000" dev

docker-machine scp \
  ./create-machine/bootsync.sh \
  dev:/tmp/bootsync.sh
docker-machine ssh dev \
  "sudo mv /tmp/bootsync.sh /var/lib/boot2docker/bootsync.sh"

echo "sleep 60sec"
sleep 60

docker-machine restart dev
docker-machine regenerate-certs dev
