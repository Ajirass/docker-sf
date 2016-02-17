FROM elasticsearch:1.7.4
MAINTAINER Robin Godart <godartrobin@gmail.com>

RUN /usr/share/elasticsearch/bin/plugin -install mobz/elasticsearch-head

VOLUME ["/usr/share/elasticsearch/data"]

COPY ./run.sh /root/run.sh
RUN chmod +x /root/*.sh

# Define default command.
CMD ["/root/run.sh"]

# Listen for 9200/tcp (HTTP) and 9300/tcp (cluster)
EXPOSE 9200 9300
