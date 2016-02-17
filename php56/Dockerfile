FROM robgd/ubuntu
MAINTAINER Robin Godart <godartrobin@gmail.com>

RUN wget -O - https://packagecloud.io/gpg.key | sudo apt-key add -
RUN add-apt-repository 'deb http://packages.blackfire.io/debian any main'

RUN apt-get update && apt-get install -y \
    php5-apcu \
    php5-cli \
    php5-common \
    php5-curl \
    php5-fpm \
    php5-gd \
    php5-geoip \
    php5-intl \
    php5-mcrypt \
    php5-mysqlnd \
    php5-readline \
    php5-redis \
    libssh2-php \
    php5-xdebug \
    libxrender1 \
    blackfire-php \
    blackfire-agent \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN php5dismod xdebug

RUN sed -i "s@listen = /var/run/php5-fpm.sock@listen = 9000@" /etc/php5/fpm/pool.d/www.conf \
    && sed -i "s@user = www-data@user = docker@" /etc/php5/fpm/pool.d/www.conf \
    && sed -i "s@group = www-data@group = docker@" /etc/php5/fpm/pool.d/www.conf

WORKDIR /var/www/$PROJECT_NAME
COPY ./conf.d/30-docker.ini /etc/php5/fpm/conf.d/30-docker.ini

COPY ./run.sh /root/run.sh
RUN chmod 775 /root/*.sh

CMD ["/root/run.sh"]

EXPOSE 9000