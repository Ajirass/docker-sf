FROM robgd/ubuntu
MAINTAINER Robin Godart <godartrobin@gmail.com>

#RUN apt-get update && apt-get install -y varnish

RUN apt-get update && apt-get install -y apt-transport-https \
    && curl https://repo.varnish-cache.org/GPG-key.txt | apt-key add - \
    && echo "deb https://repo.varnish-cache.org/ubuntu/ trusty varnish-4.1" >> /etc/apt/sources.list.d/varnish-cache.list \
    && apt-get update && apt-get install -y varnish

# Make our custom VCLs available on the container
COPY ./default.vcl /etc/varnish/default.vcl

COPY ./run.sh /root/run.sh
RUN chmod +x /root/*.sh

# Define default command.
CMD /root/run.sh

EXPOSE 80