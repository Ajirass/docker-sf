FROM robgd/ubuntu
MAINTAINER Robin Godart <godartrobin@gmail.com>

RUN apt-get update && apt-get install -y redis-server \
    && sed -i 's/^\(dir .*\)$/# \1\ndir \/data/' /etc/redis/redis.conf \
    && sed -i 's/^\(daemonize .*\)$/# \1/' /etc/redis/redis.conf \
    && sed -i 's/^\(bind .*\)$/# \1/' /etc/redis/redis.conf

VOLUME ["/data", "/var/log/redis"]

COPY ./run.sh /root/run.sh
RUN chmod +x /root/*.sh

# Define default command.
CMD ["/root/run.sh"]

EXPOSE 6379