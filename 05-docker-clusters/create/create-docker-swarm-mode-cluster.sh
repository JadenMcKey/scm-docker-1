#!/usr/bin/env bash

# Validate provided arguments
if [ $# -ne 1 ]
then
	echo "Usage: $0 <environment>"
	exit 1
fi

# Retrieve arguments
environment=$1

# Set prefix of host names
prefix="swarm-${environment}"

echo ">> Provisioning Docker Swarm Mode Clusters for environment '${environment}'..."

# Initialize Docker Swarm Mode cluster
eval $(docker-machine env ${prefix}-1)
docker swarm init --advertise-addr $(docker-machine ip ${prefix}-1)

# Retrieve token which enables to add a manager to the cluster
TOKEN=$(docker swarm join-token -q manager)

# Add all remaining hosts in this environment to the cluster
# REMARK: Loop is not executed when amount of hosts per cluster is 1
for i in $(seq 2 ${AMOUNT_OF_HOSTS_PER_CLUSTER})
do
	# Set prefix of host names
	host="${prefix}-${i}"

	# Execute next Docker commands against current host
	eval $(docker-machine env ${host})

	# Add current host as a manager to the cluster
	docker swarm join \
	  --token $TOKEN \
	  --advertise-addr $(docker-machine ip ${host}) \
	    $(docker-machine ip ${prefix}-1):2377
done

# Provision all hosts in current environment
for i in $(seq 1 ${AMOUNT_OF_HOSTS_PER_CLUSTER})
do
	# Set prefix of host names
	host="${prefix}-${i}"

	# Execute next Docker commands against current host
	eval $(docker-machine env ${host})

	# Label current host as belonging to the current environment
	docker node update \
	   --label-add env=${environment} \
	     ${host}
done

echo ">> Docker Swarm Mode Cluster for environment '${environment}' provisioned."
