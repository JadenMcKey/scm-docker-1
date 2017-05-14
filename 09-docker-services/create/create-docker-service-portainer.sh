#!/usr/bin/env bash

# Load configuration
CONFIG_CLUSTER_HOSTS=$(cat ${SCM_DOCKER_1_APPL_DOCKER_HOSTS_DIR}/data/cluster-hosts.conf)

echo "> Deploying Docker Services for Portainer:"

# Deploy Docker services in all configured environments
for config in ${CONFIG_CLUSTER_HOSTS}
do
	# Retrieve environmnet from current config element
	environment=`echo ${config} | cut -d',' -f1`

	# Set name of the first manager host in the current environment's swarm mode cluster
	host="swarm-${environment}-1"

	# Execute next Docker commands against our manager host
	eval $(docker-machine env ${host})

	# Deploy Portainer service on current Docker Swarm cluster
	docker service create \
	  --name portainer \
	   -p 8084:9000 \
	  --constraint "node.role == manager" \
	  --mount type=bind,source=/var/run/docker.sock,target=/var/run/docker.sock \
	  --mount type=volume,source=portainer-${environment}-1.vmdk,target=/data,volume-driver=rexray \
	  --network swarm-${environment}-network \
	  --reserve-memory 256m \
	    portainer/portainer \
	      -H unix:///var/run/docker.sock
done

echo "> Docker Services for Portainer deployed."
echo
