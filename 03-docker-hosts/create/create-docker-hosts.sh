#!/usr/bin/env bash

# Load configuration
CONFIG_STANDALONE_HOSTS=$(cat ${SCM_DOCKER_1_APPL_DOCKER_HOSTS_DIR}/data/standalone-hosts.conf)
CONFIG_CLUSTER_HOSTS=$(   cat ${SCM_DOCKER_1_APPL_DOCKER_HOSTS_DIR}/data/cluster-hosts.conf)

echo "> Provisioning Docker Hosts:"

# Process all config elements for standalone hosts
for config in ${CONFIG_STANDALONE_HOSTS}
do
	# Retrieve host, amount of memory and last tuple of IP address from current config element
	host=`    echo ${config} | cut -d',' -f1`
	memoryMB=`echo ${config} | cut -d',' -f2`
	ip=`      echo ${config} | cut -d',' -f3`

	# Provision hosts for current environment
	"${SCM_DOCKER_1_APPL_DOCKER_HOSTS_DIR}/create/create-docker-standalone-host.sh" ${host} ${memoryMB} ${ip}
done

# Process all config elements for hosts that will become part of Docker Swarm Mode cluster
for config in ${CONFIG_CLUSTER_HOSTS}
do
	# Retrieve environment, amount of memory and IP base from current config element
	environment=`echo ${config} | cut -d',' -f1`
	memoryMB=`   echo ${config} | cut -d',' -f2`
	ipBase=`     echo ${config} | cut -d',' -f3`

	# Provision hosts for current environment
	"${SCM_DOCKER_1_APPL_DOCKER_HOSTS_DIR}/create/create-docker-cluster-host.sh" ${environment} ${memoryMB} ${ipBase}
done

echo "> Docker Hosts provisioned."
echo
