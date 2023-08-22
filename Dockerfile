FROM php:7.3.19-apache-buster
# ARG DEBIAN_FRONTEND=noninteractive
RUN docker-php-ext-install mysqli
# Incluir controlador de base de datos alternativo
RUN docker-php-ext-install pdo
RUN docker-php-ext-install pdo_mysql

# Actualiza la lista de paquetes disponibles
RUN apt-get update

# Instalar paquetes adicionales de forma silenciosa
RUN apt-get install -y \ 
    bash-completion \
    locate \
    nano \
    openssh-server \
    rsync \
    sudo \
    tzdata

# Instalar bibliotecas de PHP de forma silenciosa
RUN apt-get install -y \ 
    libpng-dev \
#   libzip-dev \
    zlib1g-dev \
    libonig-dev \
    libedit-dev 

# Eliminar las listas de paquetes descargadas
RUN rm -rf /var/lib/apt/lists/* 

# Configurar zona horaria
ENV TZ=America/Mexico_City
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Instalar extensiones adicionales de PHP
RUN docker-php-ext-install mbstring
# RUN docker-php-ext-install zip
# RUN docker-php-ext-install gd

# Instalar extensiones adicionales de PHP para el servidor de citas
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

# Copiar todos los archivos de app/ al directorio /app/
COPY app/* /app/

# Habilitar extensión de PHP "readline"
RUN mv /app/readline.ini /usr/local/etc/php/conf.d/docker-php-ext-readline.ini

RUN cat /app/entrypoint > /usr/local/bin/docker-php-entrypoint

# Configurar claves SSH
RUN mv /app/ssh* /etc/ssh/
RUN mkdir /home/incognia/.ssh
RUN mv /app/authorized_keys /home/incognia/.ssh/authorized_keys
RUN chown -R incognia:incognia /home/incognia

# Permitir al usuario "incognia" ejecutar "sudo" sin contraseña
RUN echo "incognia ALL=(ALL:ALL) NOPASSWD: ALL" | tee /etc/sudoers.d/incognia

RUN rm -rf /app/

# Activar el módulo de reescritura en Apache
RUN a2enmod rewrite