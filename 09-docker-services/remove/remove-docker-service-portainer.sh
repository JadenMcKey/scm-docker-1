#!/usr/bin/env bash

# Load configuration
CONFIG_CLUSTER_HOSTS=$(cat ${SCM_DOCKER_1_APPL_DOCKER_HOSTS_DIR}/data/cluster-hosts.conf)

echo "> Removing Docker Services for Portainer:"

# Remove Docker services in all configured environments
for config in ${CONFIG_CLUSTER_HOSTS}
do
	# Retrieve environmnet from current config element
	environment=`echo ${config} | cut -d',' -f1`

	# Set name of the first manager host in the current environment's swarm mode cluster
	host="swarm-${environment}-1"

	# Execute next Docker commands against our manager host	
	eval $(docker-machine env ${host})

	# Remove Portainer service on current Docker Swarm cluster
	docker service rm portainer
done

echo "> Docker Services for Portainer removed."
