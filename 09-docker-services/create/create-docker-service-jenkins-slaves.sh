#!/usr/bin/env bash

# Load configuration
CONFIG_CLUSTER_HOSTS=$(cat ${SCM_DOCKER_1_APPL_DOCKER_HOSTS_DIR}/data/cluster-hosts.conf)

echo "> Deploying Docker Services for Jenkins Slaves:"

# Deploy Docker services in all configured environments
for config in ${CONFIG_CLUSTER_HOSTS}
do
	# Retrieve environmnet from current config element
	environment=`echo ${config} | cut -d',' -f1`

	# Set name of the first manager host in the current environment's swarm mode cluster
	host="swarm-${environment}-1"

	# Execute next Docker commands against our manager host
	eval $(docker-machine env ${host})

	# Create a Docker secret for Jenkins Master URL and credentials
	echo "-master http://scm:8082/jenkins -username admin -password admin123" | docker secret create jenkins-v1 -

	# Login to our private Docker registry
	docker login -u admin -p admin123 registry:5000

	# Deploy Jenkins Slave service on current Docker Swarm cluster
	docker service create \
	  --mode=global \
	  --name jenkins-swarm-client \
	   -e LABELS=docker-${environment} \
	  --mount "type=bind,source=/tmp,target=/tmp" \
	  --mount "type=bind,source=/var/run/docker.sock,target=/var/run/docker.sock" \
	  --secret source=jenkins-v1,target=jenkins \
	  --with-registry-auth \
	    registry:5000/my/jenkins-swarm-client:1
done

echo "> Docker Services for Jenkins Slaves deployed."
echo
