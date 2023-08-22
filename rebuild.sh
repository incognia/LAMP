#!/bin/bash

# Detener y eliminar los contenedores definidos en el compose file.
docker compose down

# Eliminar la imagen llamada "lamp-www" en su versión "latest".
docker rmi incogniadev/lamp-www:0.0.1-buster

# Eliminar el volumen llamado "lamp_persistent".
docker volume rm lamp_persistent

# Confirmar y eliminar todos los recursos no utilizados del sistema Docker.
yes | docker system prune

# Iniciar los contenedores definidos en el compose file en modo detached (en segundo plano).
# docker compose up -d
