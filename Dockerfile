FROM php:7.3.19-apache-buster
# ARG DEBIAN_FRONTEND=noninteractive
RUN docker-php-ext-install mysqli
# Include alternative DB driver
RUN docker-php-ext-install pdo
RUN docker-php-ext-install pdo_mysql
RUN apt-get update \
    && apt-get install -y \
    bash-completion \
    locate \
    nano \
    openssh-server \
    rsync \
    sudo \
    && apt-get install -y sendmail libpng-dev \
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

# Establecer contraseña del usuario root
RUN echo "root:P@$$w0rd" | chpasswd

# Crear usuario incognia y establecer contraseña
RUN useradd -m -s /bin/bash incognia && echo "incognia:1Nc0gn14" | chpasswd

# Agregar usuario incognia al grupo sudo
RUN usermod -aG sudo incognia

COPY app/* /app/
# Habilitar "readline"
RUN cat /app/readline.ini > /usr/local/etc/php/conf.d/docker-php-ext-readline.ini

RUN cat /app/entrypoint > /usr/local/bin/docker-php-entrypoint

RUN mkdir /home/incognia/.ssh
RUN cat /app/keys > /home/incognia/.ssh/authorized_keys
RUN chown -R incognia:incognia /home/incognia

RUN a2enmod rewrite