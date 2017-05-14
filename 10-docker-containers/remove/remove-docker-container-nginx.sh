#!/usr/bin/env bash

# NGINX container is hosted in DMZ
HOST="dmz"

echo "> Removing Docker Container for NGINX:"

# Execute next Docker commands against our intended host
eval $(docker-machine env ${HOST}) && \

# Stop and remove Docker Container for NGINX
docker stop nginx && docker rm nginx && \

# Remove data directory for NGINX container
docker-machine ssh ${HOST} rm -rf nginx

echo "> Docker Container for NGINX removed."
