#!/usr/bin/env bash

# Load configuration
CONFIG_VOLUMES=$(cat ${SCM_DOCKER_1_APPL_DOCKER_VOLUMES_DIR}/data/volumes.conf)

# Execute Docker commands against an host having REX-Ray volume driver installed
HOST="swarm-scm-1"

echo "> Creating Docker Volumes:"

# Execute next Docker commands against our intended host
eval $(docker-machine env ${HOST})

# Process all config elements
for config in ${CONFIG_VOLUMES}
do
	# Retrieve name and size of volume from current config element
	name=`echo ${config} | cut -d',' -f1`
	size=`echo ${config} | cut -d',' -f2`

	volumeExists=$(docker volume ls | grep -i rexray | grep "${name}" | wc -l)
	if (( ${volumeExists} == 0 ))
	then
		echo ">> Creating Docker Volume '${name}'..."

		# Create current docker volume
		docker volume create \
		  --driver=rexray \
		  --name=${name} \
		  --opt=size=${size}

		echo ">> Docker Volume '${name}' created."
	else
		echo ">> Docker Volume '${name}' already exists."
	fi
done

# Run a helper container to inject config data onto volume
docker run \
  --detach \
  --volume-driver rexray \
  --volume jenkins-1.vmdk:/data \
  --name helper \
    busybox sh -c "while :; do sleep 10; done" && \

# Copy Jenkins volume to provide a pre-configured setup and data
#docker cp "${SCM_DOCKER_1_APPL_DOCKER_VOLUMES_DIR}/data/jenkins-1.tar.gz" "helper:/data/" && \
#docker exec helper tar xvfpz /data/jenkins-1.tar.gz -C /data/ && \
#docker exec helper rm /data/jenkins-1.tar.gz && \

# Copy Jenkins volume to provide a pre-configured setup and data
ls ${SCM_DOCKER_1_APPL_DOCKER_VOLUMES_DIR}/data/jenkins-1.tgz.* | awk -F'.' '{ print $3 }' | while read seqNr
do
	docker cp "${SCM_DOCKER_1_APPL_DOCKER_VOLUMES_DIR}/data/jenkins-1.tgz.${seqNr}" "helper:/data/"
done
docker exec helper sh -c 'cd /data && cat /data/jenkins-1.tgz.* | tar xzpvf -' && \
docker exec helper sh -c 'rm /data/jenkins-1.tgz.*' && \

# Stop and remove helper container
docker stop helper && docker rm helper

echo "> Docker Volumes created."
echo
