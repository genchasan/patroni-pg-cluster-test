#!/bin/sh

podman run -d --name etcd1 -h etcd1 -v $PWD/etcd.conf.1:/etc/etcd/etcd.conf --network testnet --ip 192.168.5.11 r9-etcd

podman run -d --name etcd2 -h etcd2 -v $PWD/etcd.conf.2:/etc/etcd/etcd.conf --network testnet --ip 192.168.5.12 r9-etcd

podman run -d --name etcd3 -h etcd3 -v $PWD/etcd.conf.3:/etc/etcd/etcd.conf --network testnet --ip 192.168.5.13 r9-etcd

