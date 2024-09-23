FROM localhost/r9-systemd

ENV ETCD_VER=v3.4.34

ENV GOOGLE_URL=https://storage.googleapis.com/etcd
ENV GITHUB_URL=https://github.com/etcd-io/etcd/releases/download
ENV DOWNLOAD_URL=${GOOGLE_URL}

ARG ETCD_LISTEN_PEER_URLS=http://0.0.0.0:2380
ARG ETCD_LISTEN_CLIENT_URLS=http://0.0.0.0:2379
ARG ETCD_INITIAL_ADVERTISE_PEER_URLS=http://etcd1:2380
ARG ETCD_ADVERTISE_CLIENT_URLS=http://etcd1:2379
ARG ETCD_NAME="etcd1"

RUN mkdir -p /tmp/etcd-download-test && \
	curl -L ${DOWNLOAD_URL}/${ETCD_VER}/etcd-${ETCD_VER}-linux-amd64.tar.gz -o /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz

RUN	tar xzvf /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz -C /tmp/etcd-download-test --strip-components=1 && \
	rm -f /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz && \ 
	cd /tmp/etcd-download-test && \
	mv etcd* /usr/local/bin && \
	mkdir -p /var/lib/etcd/ && \
	mkdir /etc/etcd &&  \
	groupadd --system etcd && \
	useradd -s /sbin/nologin --system -g etcd etcd && \
	chown -R etcd:etcd /var/lib/etcd/ && chmod 0775 /var/lib/etcd/

RUN cat > /etc/systemd/system/etcd.service <<END
[Unit]
Description=Etcd - Highly Available Key Value Store
Documentation=hman:etcd
After=network.target
Wants=network-online.target
[Service]
Environment=DAEMON_ARGS=
Environment=ETCD_NAME=%H
Environment=ETCD_DATA_DIR=/var/lib/etcd/default
EnvironmentFile=/etc/etcd/etcd.conf
Type=notify
User=etcd
PermissionsStartOnly=true
# set GOMAXPROCS to number of processors
#ExecStart=/bin/bash -c "GOMAXPROCS=$(nproc) /usr/bin/etcd --name=\"${ETCD_NAME}\" --datadir=\"${ETCD_DATA_DIR}\" --listen-client-urls=\"${ETCD_LISTEN_CLIENT_URLS}\""
ExecStart=/usr/local/bin/etcd $DAEMON_ARGS
Restart=on-abnormal
LimitNOFILE=65536
[Install]
WantedBy=multi-user.target
END

RUN cat > /etc/etcd/etcd.conf <<END
[Member]
ETCD_LISTEN_PEER_URLS="${ETCD_LISTEN_PEER_URLS}"
ETCD_LISTEN_CLIENT_URLS="${ETCD_LISTEN_CLIENT_URLS}"
ETCD_DATA_DIR="/var/lib/etcd/default"
[Clustering]
ETCD_INITIAL_ADVERTISE_PEER_URLS="${ETCD_INITIAL_ADVERTISE_PEER_URLS}"
ETCD_ADVERTISE_CLIENT_URLS="${ETCD_ADVERTISE_CLIENT_URLS}"
ETCD_INITIAL_CLUSTER="etcd1=http://etcd1:2380,etcd2=http://etcd2:2380,etcd3=http://etcd3:2380"
ETCD_INITIAL_CLUSTER_TOKEN="etcd-cluster"
ETCD_INITIAL_CLUSTER_STATE="new"
ETCD_NAME="${ETCD_NAME}"
ETCD_ELECTION_TIMEOUT=5000
ETCD_HEARTBEAT_INTERVAL=1000
ETCD_ENABLE_V2=true
END

RUN systemctl enable etcd
RUN systemctl enable sshd.service