FROM localhost/r9-postgresql


USER postgres

RUN /usr/pgsql-${POSTGRESQL_VER}/bin/pg_ctl start && \
    /usr/pgsql-${POSTGRESQL_VER}/bin/pg_ctl status && \
    /usr/pgsql-${POSTGRESQL_VER}/bin/createuser -S --replication replicator && \
    /usr/pgsql-${POSTGRESQL_VER}/bin/pg_ctl stop 


USER root


RUN yum install patroni -y && \
    yum install python3-urllib3 -y && \
    yum install patroni-etcd -y

ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

RUN systemctl enable patroni

RUN echo "host    replication    all    192.168.5.0/24    trust" >> $PGDATA/pg_hba.conf
RUN echo "host    all    all    192.168.5.0/24    trust" >> $PGDATA/pg_hba.conf
RUN echo "192.168.5.32:5432:*:postgres:" > $HOME/.pgpass && chmod 0600 $HOME/.pgpass
RUN echo "192.168.5.32:5432:*:replicator:" >> $HOME/.pgpass && chmod 0600 $HOME/.pgpass


ENTRYPOINT ["/usr/sbin/init"]

CMD ["/bin/bash"]