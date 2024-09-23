# patroni-pg-cluster-test

Patroni kullanarak PostgreSQL veritabanı cluster testleri için konteyner oluşturma ve çalıştırma scriptlerini içerir.

Konteyner ortamı için docker yerine podman kullanılmıştır. Bir konteyner içinde birden fazla servis(process) çalışması için systemd kullanılması durumunda docker içinde çalıştırmak problemli olmaktadır. Podman ile benzer bir konteyner teknolojisi ve birden fazla servisi çalıştıran systemd prosesi problem çıkartmamıştır.


Örnek topoloji için aşağıdaki komut ile özel network oluşturularak başlandı.

```
podman network create --subnet=192.168.5.0/24 testnet
```

Örnek topoloji için oluşturulacak makinelerin IP adresleri
```
HOSTNAME 		IP ADDRESS 			PURPOSE
node1 			192.168.5.31  		Postgresql+Patroni
node2 			192.168.5.32  		Postgresql+Patroni
etcd1 			192.168.5.11  		etcd Cluster
etcd2 			192.168.5.12  		etcd Cluster
etcd3 			192.168.5.13  		etcd Cluster
ha1 			192.168.5.21  		HAProxy
ha2 			192.168.5.22  		HAProxy_Backup
Pgbackrest 		192.168.5.100 		Pgbackrest(Backup)
VIP IP 			192.168.5.200 		Virtual IP for Patroni

```

Bu makineleri çalıştırırken hepsini aynı network içinde çalıştırıcağız.