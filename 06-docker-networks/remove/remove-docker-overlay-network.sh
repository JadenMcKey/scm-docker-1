#!/usr/bin/env bash

# Load configuration
CONFIG_CLUSTER_HOSTS=$(cat ${SCM_DOCKER_1_APPL_DOCKER_HOSTS_DIR}/data/cluster-hosts.conf)

echo "> Destroying Docker Overlay Networks:"

# Remove Docker overlay networks in all configured environments
for config in ${CONFIG_CLUSTER_HOSTS}
do
	# Retrieve environmnet from current config element
	environment=`echo ${config} | cut -d',' -f1`

	# Set prefix of host names
	prefix="swarm-${environment}"

	# Set name of the first manager host in the current environment's swarm mode cluster
	managerHost="${prefix}-1"

	# Set name of the overlay network for this environment's swarm mode cluster
	networkName="${prefix}-network"

	echo ">> Destroying network '${networkName}'..."

	# Execute next Docker commands against our manager host
	eval $(docker-machine env ${managerHost})

	# Remove the current overlay network
	docker network rm ${networkName}

	echo ">> Network '${networkName}' destroyed."
done

echo "> Docker Overlay Networks destroyed."
echo
