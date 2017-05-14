#!/usr/bin/env bash

# Load configuration
CONFIG_VOLUMES=$(cat ${SCM_DOCKER_1_APPL_DOCKER_VOLUMES_DIR}/data/volumes.conf)

# Execute Docker commands against an host having REX-Ray volume driver installed
HOST="swarm-scm-1"

# List of Gitblit repositories to create
REPOSITORIES="
  cd-demo
  gs-spring-boot-docker-complete"

echo "> Removing Docker Volumes:"

# Execute next Docker commands against our intended host
eval $(docker-machine env ${HOST})

# Process all config elements
for config in ${CONFIG_VOLUMES}
do
	# Retrieve name and size of volume from current config element
	name=`echo ${config} | cut -d',' -f1`
	size=`echo ${config} | cut -d',' -f2`

	volumeExists=$(docker volume ls | grep -i rexray | grep "${name}" | wc -l)
	if (( ${volumeExists} == 1 ))
	then
		echo ">> Removing Docker Volume '${name}'..."
		docker volume remove ${name}
		echo ">> Docker Volume '${name}' removed."
	else
		echo ">> Docker Volume '${name}' does not exist."
	fi
done

echo "> Docker Volumes created."

echo "> Unlink source code projects:"

for repository in ${REPOSITORIES}
do
	echo ">> Unlinking project '${repository}'..."
	rm -rf "${SCM_DOCKER_1_APPL_GIT_DIR}/${repository}/.git"
	echo ">> Project '${repository}' unlinked."
done

echo "> Source code projects unlinked."
echo
