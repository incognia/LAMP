FROM php:7.3.19-apache-buster
# ARG DEBIAN_FRONTEND=noninteractive
RUN docker-php-ext-install mysqli
# Include alternative DB driver
RUN docker-php-ext-install pdo
RUN docker-php-ext-install pdo_mysql
RUN apt-get update \
    && apt-get install -y nano sendmail libpng-dev \
#   && apt-get install -y libzip-dev \
    && apt-get install -y zlib1g-dev \
    && apt-get install -y libonig-dev \
# Instalar dependencias de "readline"
    && apt-get install -y libedit-dev \
    && rm -rf /var/lib/apt/lists/* 
#   && docker-php-ext-install zip

RUN docker-php-ext-install mbstring
# RUN docker-php-ext-install zip
# RUN docker-php-ext-install gd

# Extra modules for "Citas"
RUN docker-php-ext-install \
    calendar \
    exif \
    gettext \
    readline \
    shmop \
    sockets \
    sysvmsg \
    sysvsem \
    sysvshm \
    opcache

COPY app/* /app/
RUN cat /app/readline.ini > /usr/local/etc/php/conf.d/docker-php-ext-readline.ini

RUN a2enmod rewrite