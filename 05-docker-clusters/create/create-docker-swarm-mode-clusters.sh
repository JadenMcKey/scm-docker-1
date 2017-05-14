#!/usr/bin/env bash

# Load configuration
CONFIG_CLUSTER_HOSTS=$(cat ${SCM_DOCKER_1_APPL_DOCKER_HOSTS_DIR}/data/cluster-hosts.conf)

echo "> Provisioning Docker Swarm Mode Clusters:"

# Create Docker clusters in all configured environments
for config in ${CONFIG_CLUSTER_HOSTS}
do
	# Retrieve environmnet from current config element
	environment=`echo ${config} | cut -d',' -f1`

	# Provision cluster in current environment
	"${SCM_DOCKER_1_APPL_DOCKER_CLUSTERS_DIR}/create/create-docker-swarm-mode-cluster.sh" ${environment}
done

echo "> Docker Swarm Mode Clusters provisioned."
echo
