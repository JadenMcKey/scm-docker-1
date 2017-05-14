#!/usr/bin/env bash

CONTAINERS="
  gitblit
  nginx"

echo "> Deploying All Docker Containers:"

# Deploy all configured containers
for container in ${CONTAINERS}
do
	# Deploy current container
	${SCM_DOCKER_1_APPL_DOCKER_CONTAINERS_DIR}/create/create-docker-container-${container}.sh
done

echo "> All Docker Containers deployed."
echo
