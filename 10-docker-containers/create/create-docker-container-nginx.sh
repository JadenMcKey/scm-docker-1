#!/usr/bin/env bash

# NGINX container is hosted in DMZ
HOST="dmz"

echo "> Starting Docker Container for NGINX:"

# Docker Machine SCP only supports transfer of files in current directory
cp "${SCM_DOCKER_1_APPL_DOCKER_CONTAINERS_DIR}/data/nginx/conf.d/default.conf" . && \

# Create data directory Docker host to be shared with Docker container
docker-machine ssh ${HOST} mkdir -p nginx/conf.d && \

# Copy NGINX configuration data
docker-machine scp default.conf ${HOST}:nginx/conf.d && \

# Execute next Docker commands against our intended host
eval $(docker-machine env ${HOST})

# Run Docker Container for NGINX
# TODO: Instead of copy TAR into docker machine use a REX-Ray volume
docker run -d \
  --publish  80:80  \
  --publish 443:443 \
  --volume /home/docker/nginx/conf.d:/etc/nginx/conf.d \
  --name nginx \
    nginx

# Remove temporary files copied to current directory for SCP into Docker host
rm default.conf

echo "> Docker Container for NGINX started."
