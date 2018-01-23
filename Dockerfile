FROM php:7.0.27-apache-jessie

MAINTAINER "jmpg"

ENV SERVER_NAME="localhost"
ENV WEBSERVER_USER="www-data"
ENV USER_ID="1001"
ENV USER_GROUP="999"
ENV USER_NAME="magento2"

ENV PHP_MEMORY_LIMIT="2G"
ENV PHP_MAXEXECUTION_TIME="18000"
ENV PHP_UPLOAD_MAX_FILESIZE="100M"
ENV PHP_POST_MAX_SIZE="100M"
ENV PHP_MAX_IMPUT_VARS="5000"
ENV PHP_DISPLAY_ERRORS="On"

WORKDIR /tmp

RUN apt-get update && apt-get install -y \
    apt-utils \
    ssh \
    wget \
    unzip \
    cron \
    curl \
    libmcrypt-dev \
    libicu-dev \
    libxml2-dev \
    libxslt1-dev \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libexpat1-dev \
    libpng12-dev \
    libcurl4-gnutls-dev \
    libz-dev \
    libssl-dev \
    build-essential \
    tcl8.5 \
    gettext \
    lsof \
    vim \
    supervisor \
    mysql-client \
    ocaml \
    expect \
    librabbitmq-dev \
    erlang-nox \
    logrotate \
    socat \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir /build/ \

    ## PHP
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-configure hash --with-mhash \
    && docker-php-ext-install -j$(nproc) mcrypt mbstring intl xsl gd zip pdo_mysql opcache soap bcmath json iconv \
    && docker-php-ext-install bcmath \

    ## Composer
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && rm -rf /usr/local/etc/php-fpm.d/*

    ## Xdebug
    RUN cd /tmp && wget -c "http://xdebug.org/files/xdebug-2.5.0.tgz" \
        && tar -xf xdebug-2.5.0.tgz \
        && cd xdebug-2.5.0 \
        && phpize \
        && ./configure \
        && make && make install

    ## Git
    RUN cd /tmp && wget https://www.kernel.org/pub/software/scm/git/git-2.9.2.tar.gz
    RUN tar -xzf git-2.9.2.tar.gz
    RUN cd /tmp/git-2.9.2 && make configure && ./configure --prefix=/usr/local && make install

    ## Grunt
    WORKDIR /tmp/grunt
    RUN curl -sL https://deb.nodesource.com/setup | bash -
    RUN apt-get update \
        && apt-get install -y build-essential nodejs
    RUN npm install -g express \
        && npm install -g grunt-cli

    ##configurar aqui apache

    # supervisord config
    RUN rm /etc/supervisor/supervisord.conf
    COPY conf/supervisord.conf /etc/supervisord.conf

    # entrypoint
    COPY bin/entrypoint.sh /usr/local/bin/
    RUN chmod +x /usr/local/bin/entrypoint.sh

    EXPOSE 80 44100
    WORKDIR /var/www/html
    USER root
    ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
