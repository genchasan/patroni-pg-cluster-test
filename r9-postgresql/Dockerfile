FROM localhost/r9-systemd

ARG TARGETPLATFORM
ARG POSTGRESQL_VER=16
ENV POSTGRESQL_VER=${POSTGRESQL_VER}
ENV PGDATA=/var/lib/pgsql/${POSTGRESQL_VER}/data

ARG TARGETPLATFORM
RUN echo "I'm building for $TARGETPLATFORM"

USER root

RUN systemctl enable sshd.service

RUN if [ "$TARGETPLATFORM" = "linux/amd64" ]; \
        then ARCHITECTURE=x86_64; \
    elif [ "$TARGETPLATFORM" = "linux/arm/v7" ]; \
        then ARCHITECTURE=arm; \
    elif [[ "$TARGETPLATFORM" == *"linux/arm64"* ]]; \
        then ARCHITECTURE=aarch64; \
    else ARCHITECTURE=x86_64; fi && \
    dnf install -y epel-release && \
	dnf config-manager --enable crb && \
    dnf install -y https://download.postgresql.org/pub/repos/yum/reporpms/EL-9-${ARCHITECTURE}/pgdg-redhat-repo-latest.noarch.rpm && \
    dnf -qy module disable postgresql && \
    dnf install -y postgresql${POSTGRESQL_VER}-server && \
    dnf install -y postgresql${POSTGRESQL_VER}-contrib && \
    dnf install -y postgresql${POSTGRESQL_VER}-devel && \
    systemctl enable postgresql-${POSTGRESQL_VER} && \
    dnf install -y perl-IPC-Run && \
    yum install -y langpacks-tr.noarch && \
	dnf -y -q install glibc-langpack-en && \
	dnf -y -q install glibc-langpack-tr wget unzip pgbackrest pg_dirtyread_16


ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

USER postgres

# Initialize PostgreSQL cluster
RUN /usr/pgsql-${POSTGRESQL_VER}/bin/initdb -D /var/lib/pgsql/${POSTGRESQL_VER}/data

#RUN sed -i "/^#listen_addresses/,/^$/d" /var/lib/pgsql/${POSTGRESQL_VER}/data/postgresql.conf
RUN sed -i "s|^[?#]listen_addresses =.*|listen_addresses = '*'|" /var/lib/pgsql/${POSTGRESQL_VER}/data/postgresql.conf

RUN sed -i "s|^#wal_level =.*|wal_level = replica |" /var/lib/pgsql/${POSTGRESQL_VER}/data/postgresql.conf

RUN sed -i "s|^#archive_mode =.*|archive_mode = on |" /var/lib/pgsql/${POSTGRESQL_VER}/data/postgresql.conf

RUN mkdir /var/lib/pgsql/archive

RUN sed -i "s|^#archive_command =.*|archive_command = 'cp %p /var/lib/pgsql/archive/%f' |" /var/lib/pgsql/${POSTGRESQL_VER}/data/postgresql.conf

RUN sed -i "s|^[?#]log_rotation_age =.*|log_rotation_age = 1d |" /var/lib/pgsql/${POSTGRESQL_VER}/data/postgresql.conf

RUN sed -i "s|^[?#]log_lock_waits =.*|log_lock_waits = on |" /var/lib/pgsql/${POSTGRESQL_VER}/data/postgresql.conf

RUN sed -i "s|^[?#]log_statement =.*|log_statement = 'ddl' |" /var/lib/pgsql/${POSTGRESQL_VER}/data/postgresql.conf


RUN sed -i "s|^[?#]log_connections =.*|log_connections = on |" /var/lib/pgsql/${POSTGRESQL_VER}/data/postgresql.conf

RUN sed -i "s|^log_line_prefix =.*|log_line_prefix = '%t [%p]: [%l-1] user=%u,db=%d,app=%a,client=%h' |" /var/lib/pgsql/${POSTGRESQL_VER}/data/postgresql.conf

RUN sed -i "s|^log_filename =.*|log_filename = 'postgresql-%Y-%m-%d_%H%M%S.log' |" /var/lib/pgsql/${POSTGRESQL_VER}/data/postgresql.conf

# Allow postgresql password acess from localhost
#RUN sed -i -r -e 's/host\s+all\s+all\s+127.0.0.1\/32\s+ident/host all all 127.0.0.1\/32 password/' /var/lib/pgsql/${POSTGRESQL_VER}/data/pg_hba.conf

RUN cat > /var/lib/pgsql/.bash_profile <<END
#!/bin/bash

PATH=/usr/pgsql-${POSTGRESQL_VER}/bin:$PATH:$HOME/bin
PGDATA=/var/lib/pgsql/${POSTGRESQL_VER}/data
PGPORT=5432
PGUSER=postgres
export PATH PGDATA PGPORT PGUSER
pg_ctl status
PS1='\`whoami\` \$PWD>'
alias alert='cd /var/lib/pgsql/${POSTGRESQL_VER}/data/log'
alias alertlog='tail -100f `ls -t | head -n1`'
alias dbs="ps aux|grep postgres"
alias oh="cd $PGDATA"
alias ltr="ls -latr"
END


RUN chmod 755 /var/lib/pgsql

# Add VOLUMEs to allow backup of config, logs and databases
VOLUME  [ "/var/lib/pgsql"]

RUN systemctl enable postgresql-${POSTGRESQL_VER}.service

EXPOSE 5432

USER root

ENTRYPOINT ["/usr/sbin/init"]

CMD ["/bin/bash"]