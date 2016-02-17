FROM robgd/ubuntu
MAINTAINER Robin Godart <godartrobin@gmail.com>

RUN wget -O - https://packagecloud.io/gpg.key | sudo apt-key add -
RUN add-apt-repository 'deb http://packages.blackfire.io/debian any main'

RUN apt-get update && apt-get install -y \
    php5-cli php5-json php5-intl php5-mysqlnd php5-curl php5-redis php5-apcu php5-xdebug libssh2-php checkinstall nodejs libxrender1 libfontconfig1 \
    npm redis-tools mysql-client blackfire-php blackfire-agent \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN php5dismod xdebug

RUN ln -s /usr/bin/nodejs /usr/bin/node

RUN npm install -g redis-commander && \
    npm install -g gulp

RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer

COPY ./conf.d/30-docker.ini /etc/php5/cli/conf.d/30-docker.ini
COPY ./run.sh /home/docker/run.sh

RUN chown docker:docker /home/docker/run.sh \
    && chmod +x /home/docker/*.sh

USER docker
ENV HOME /home/docker

WORKDIR /var/www/robgd

# Define default command.
CMD ["/home/docker/run.sh"]

EXPOSE 8081