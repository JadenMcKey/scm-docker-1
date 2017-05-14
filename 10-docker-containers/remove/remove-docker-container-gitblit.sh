#!/usr/bin/env bash

# Execute Docker commands against the host running the Internet application containers
HOST="int"

echo "> Removing Docker Container for Gitblit:"

# Execute next Docker commands against our intended host
eval $(docker-machine env ${HOST}) && \

# Stop and remove Docker container for Gitblit
docker stop gitblit && docker rm gitblit

echo "> Docker Container for Gitblit removed."
