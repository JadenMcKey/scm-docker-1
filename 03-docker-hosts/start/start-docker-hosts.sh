#!/usr/bin/env bash

# Load configuration
CONFIG_STANDALONE_HOSTS=$(cat ${SCM_DOCKER_1_APPL_DOCKER_HOSTS_DIR}/data/standalone-hosts.conf)
CONFIG_CLUSTER_HOSTS=$(   cat ${SCM_DOCKER_1_APPL_DOCKER_HOSTS_DIR}/data/cluster-hosts.conf)

echo "> Starting Docker Hosts:"

# Process all config elements for standalone hosts
for config in ${CONFIG_STANDALONE_HOSTS}
do
	# Retrieve host from current config element
	host=`echo ${config} | cut -d',' -f1`

	echo ">> Starting host '${host}'..."

	# Start current host
	docker-machine start ${host}

	echo ">> Host '${host}' destroyed."	
done

# Process all config elements for hosts that are part of Docker Swarm Mode cluster
for config in ${CONFIG_CLUSTER_HOSTS}
do
	# Retrieve environmnet from current config element
	environment=`echo ${config} | cut -d',' -f1`

	echo ">> Starting environment '${environment}'..."

	# Set prefix of host names
	prefix="swarm-${environment}"

	# Remove all hosts in current environment
	for i in $(seq 1 ${AMOUNT_OF_HOSTS_PER_CLUSTER})
	do
		echo ">>> Starting host ${i}..."

		# Set name of current host
		host="${prefix}-${i}"
		
		# Start current host
		docker-machine start ${host}

		echo ">>> Host ${i} started."
	done

	echo ">> Environment '${environment}' started."
done

echo "> Docker Hosts started."
echo
