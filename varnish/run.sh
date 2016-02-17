#!/bin/bash

varnishd -f $VCL_CONFIG -s malloc,$CACHE_SIZE &

tail -f /dev/null