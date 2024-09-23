#!/bin/sh

podman run -d --name haproxy1 -h haproxy1 -v ./keepalived.conf.master:/etc/keepalived/keepalived.conf --network testnet --ip 192.168.5.21 -p 7001:7000 -p 9000:5000 --cap-add NET_ADMIN --privileged r9-haproxy

podman run -d --name haproxy2 -h haproxy2 -v ./keepalived.conf.backup:/etc/keepalived/keepalived.conf --network testnet --ip 192.168.5.22 -p 7002:7000 -p 9001:5000 --cap-add NET_ADMIN --privileged r9-haproxy
