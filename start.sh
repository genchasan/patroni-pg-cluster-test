#!/bin/sh

# Conteyner ortamı icin network olustur

echo "Test network olusturulacak.."
podman network create --subnet=192.168.5.0/24 testnet 

(
	echo "Etcd cluster olusturulacak"
	cd r9-etcd
	./start-etcd-cluster.sh
)

(
	echo "HAProxy load balancer olusturulacak"
	cd r9-haproxy
	./start-haproxy.sh
)

(
	echo "Patroni nodelar olusturulacak"
	cd r9-pgnode
	./start-pgnode.sh
)