#!/usr/bin/env bash

CONTAINERS="
  nginx
  gitblit"

echo "> Removing All Docker Containers:"

# Deploy all configured containers
for container in ${CONTAINERS}
do
	# Deploy current container
	${SCM_DOCKER_1_APPL_DOCKER_CONTAINERS_DIR}/remove/remove-docker-container-${container}.sh
done

echo "> All Docker Containers removed."
echo
