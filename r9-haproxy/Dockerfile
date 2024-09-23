FROM localhost/r9-systemd

ARG VIRTUAL_IP_ADRESS=192.168.5.200
ARG KEEPALIVED_MODE=MASTER
ARG KEEPALIVED_PRIORITY=101


RUN dnf install -y gcc openssl openssl-devel

RUN cd /tmp && wget https://www.keepalived.org/software/keepalived-2.2.8.tar.gz && \
	tar xvzf keepalived-2.2.8.tar.gz && \
	cd keepalived-2.2.8 && \
	./configure && \
	make && \
	make install

RUN cd /tmp && wget https://www.haproxy.org/download/2.8/src/haproxy-2.8.3.tar.gz && \
	tar xzzf haproxy-2.8.3.tar.gz && \
	cd haproxy-2.8.3 && \
	make TARGET=linux-glibc && \
	make install && \
	mkdir -p /etc/haproxy

RUN	mkdir -p /etc/keepalived

RUN cat > /etc/keepalived/keepalived.conf <<END
! Configuration File for keepalived
global_defs {
}
vrrp_script chk_haproxy { # Requires keepalived-1.1.13
 script "killall -0 haproxy" # widely used idiom
 interval 2 # check every 2 seconds
 weight 2 # add 2 points of prio if OK
}
vrrp_instance VI_1 {
 interface eth0
 state ${KEEPALIVED_MODE} # or "BACKUP" on backup
 priority ${KEEPALIVED_PRIORITY} # 101 on master, 100 on backup
 virtual_router_id 51
 authentication {
 	auth_type PASS
 	auth_pass 1234
 }
 virtual_ipaddress {
 	${VIRTUAL_IP_ADRESS}
 }
 track_script {
 	chk_haproxy
 }
}
END

COPY haproxy.service /usr/lib/systemd/system/haproxy.service

RUN cat > /etc/haproxy/haproxy.cfg <<END
global
	maxconn 100
	log 127.0.0.1 local2
	
defaults
	log global
	mode tcp
	retries 2
	timeout client 30m
	timeout connect 4s
	timeout server 30m
	timeout check 5s
listen stats
	mode http
	bind *:7000
	stats enable
	stats uri /
	stats refresh 5s
listen postgres
	bind 192.168.5.200:5000
	option httpchk
	http-check expect status 200
	default-server inter 3s fall 3 rise 2 on-marked-down shutdown-sessions
	server node1 192.168.5.31:5432 maxconn 1000 check port 8008
	server node2 192.168.5.32:5432 maxconn 1000 check port 8008
END

EXPOSE 5000

RUN systemctl enable sshd.service
RUN systemctl enable keepalived
RUN systemctl enable haproxy.service

CMD ["/usr/sbin/init"]
