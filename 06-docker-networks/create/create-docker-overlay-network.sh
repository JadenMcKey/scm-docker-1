#!/usr/bin/env bash

# Load configuration
CONFIG_CLUSTER_HOSTS=$(cat ${SCM_DOCKER_1_APPL_DOCKER_HOSTS_DIR}/data/cluster-hosts.conf)

echo "> Creating Docker Overlay Networks:"

# Process all config elements
for config in ${CONFIG_CLUSTER_HOSTS}
do
	# Retrieve environment and IP base from current config element
	environment=`echo ${config} | cut -d',' -f1`
	ipBase=`     echo ${config} | cut -d',' -f3`

	# Set prefix of host names
	prefix="swarm-${environment}"

	# Set name of the first manager host in the current environment's swarm mode cluster
	managerHost="${prefix}-1"

	# Set name of the overlay network for this environment's swarm mode cluster
	networkName="${prefix}-network"

	echo ">> Provisioning network '${networkName}'..."

	# Execute next Docker commands against our manager host
	eval $(docker-machine env ${managerHost})

	# Create the current overlay network
	docker network create \
	  --driver overlay \
	  --subnet 10.0.${ipBase}.0/24 \
	    ${networkName}

	echo ">> Network '${networkName}' provisioned."
done

echo "> Docker Overlay Networks created."
echo
