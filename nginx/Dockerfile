FROM robgd/ubuntu
MAINTAINER Robin Godart <godartrobin@gmail.com>

RUN apt-get update && apt-get install -y nginx php5-common php5-curl php5-fpm \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y phpmyadmin \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY ./nginx.conf /etc/nginx/
COPY ./sites-available/docker /etc/nginx/sites-available/docker
COPY ./sites-available/phpmyadmin /etc/nginx/sites-available/phpmyadmin

COPY ./config.inc.php /etc/phpmyadmin/config.inc.php
RUN mkdir -p /var/www
RUN ln -s /usr/share/phpmyadmin /var/www/phpmyadmin
RUN ln -s /etc/nginx/sites-available/docker /etc/nginx/sites-enabled/docker
RUN ln -s /etc/nginx/sites-available/phpmyadmin /etc/nginx/sites-enabled/phpmyadmin
RUN rm /etc/nginx/sites-enabled/default

RUN echo "upstream php-upstream { server php:9000; }" > /etc/nginx/conf.d/upstream.conf

COPY ./run.sh /root/run.sh
RUN chmod +x /root/*.sh

# Define default command.
CMD ["/root/run.sh"]

EXPOSE 80
#EXPOSE 8080
EXPOSE 443
