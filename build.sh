#!/bin/sh

(
	echo "Base sistem imaji olusturulacak"
	cd r9-systemd
	./build.sh
)

(
	echo "Etcd cluster icin imaj olusturulacak"
	cd r9-etcd
	./build-etcd.sh
)


(
	echo "HAProxy icin imaj olusturulacak"
	cd r9-haproxy
	./build-haproxy.sh
)

(
	echo "Postgressql nodelar icin imaj olusturulacak"
	cd r9-postgresql
	./build-postgresql.sh
)

(
	echo "Patroni nodelar icin imaj olusturulacak"
	cd r9-pgnode
	./build-pgnode.sh
)