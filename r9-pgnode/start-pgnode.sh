#!/bin/sh

podman run -d --name pgnode1 -h pgnode1 -v ./patroni.1.yml:/etc/patroni/patroni.yml --network testnet --ip 192.168.5.31 -p 15432:5432 r9-pgnode

podman run -d --name pgnode2 -h pgnode2 -v ./patroni.2.yml:/etc/patroni/patroni.yml --network testnet --ip 192.168.5.32 -p 25432:5432 r9-pgnode
