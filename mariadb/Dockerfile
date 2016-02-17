FROM robgd/ubuntu
MAINTAINER Robin Godart <godartrobin@gmail.com>

# add our user and group first to make sure their IDs get assigned consistently, regardless of whatever dependencies get added
RUN groupadd -r mysql && useradd -r -g mysql mysql

RUN apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 0xcbcb082a1bb943db

RUN add-apt-repository 'deb [arch=amd64,i386] http://mirror6.layerjet.com/mariadb/repo/10.1/ubuntu trusty main'

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y mariadb-server python-pip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Define mountable directories.
VOLUME ["/etc/mysql", "/var/lib/mysql"]

COPY ./prod.sql.tar.gz /root/prod.sql.tar.gz
COPY ./conf/my.cnf /etc/mysql/conf.d/my.cnf
COPY ./scripts/functions.sh /root/scripts/functions.sh
COPY ./scripts/run.sh /root/run.sh
RUN chmod +x /root/*.sh

# Define default command.
CMD ["/root/run.sh"]

EXPOSE 3306
