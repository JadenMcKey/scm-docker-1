#!/usr/bin/env bash

# Load configuration
CONFIG_STANDALONE_HOSTS=$(cat ${SCM_DOCKER_1_APPL_DOCKER_HOSTS_DIR}/data/standalone-hosts.conf)
CONFIG_CLUSTER_HOSTS=$(   cat ${SCM_DOCKER_1_APPL_DOCKER_HOSTS_DIR}/data/cluster-hosts.conf)

echo "> Stopping Docker Hosts:"

# Process all config elements for standalone hosts
for config in ${CONFIG_STANDALONE_HOSTS}
do
	# Retrieve host from current config element
	host=`echo ${config} | cut -d',' -f1`

	echo ">> Stopping host '${host}'..."

	# Stop current host
	docker-machine stop ${host}

	echo ">> Host '${host}' stopped."	
done

# Process all config elements for hosts that are part of Docker Swarm Mode cluster
for config in ${CONFIG_CLUSTER_HOSTS}
do
	# Retrieve environmnet from current config element
	environment=`echo ${config} | cut -d',' -f1`

	echo ">> Stopping environment '${environment}'..."

	# Set prefix of host names
	prefix="swarm-${environment}"

	# Remove all hosts in current environment
	for i in $(seq 1 ${AMOUNT_OF_HOSTS_PER_CLUSTER})
	do
		echo ">>> Stopping host ${i}..."

		# Set name of current host
		host="${prefix}-${i}"
		
		# Stop current host
		docker-machine stop ${host}

		echo ">>> Host ${i} stopped."
	done

	echo ">> Environment '${environment}' stopped."
done

echo "> Docker Hosts stopped."
echo
