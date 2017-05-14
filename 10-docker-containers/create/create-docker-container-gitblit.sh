#!/usr/bin/env bash

# Execute Docker commands against the host running the Internet application containers
HOST="int"

echo "> Deploying Docker Container for Gitblit:"

# Execute next Docker commands against our intended host
eval $(docker-machine env ${HOST}) && \

# Run Docker Container for Gitblit
docker run -d \
  --name gitblit \
  --publish 8081:8080 --publish  8444:8443  \
  --publish 9418:9418 --publish 29418:29418 \
  --volume-driver rexray \
  --volume gitblit-1.vmdk:/opt/gitblit-data \
    jacekkow/gitblit && \

echo "> Docker Container for Gitblit deployed."
echo


# Configure Gitblit
${SCM_DOCKER_1_APPL_DOCKER_CONTAINERS_DIR}/create/gitblit/configure-gitblit.sh
