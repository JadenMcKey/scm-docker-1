#!/usr/bin/env bash

# Validate provided arguments
if [ $# -ne 3 ]
then
	echo "Usage: $0 <environment> <memory_mb> <ip_base>"
	exit 1
fi

# Retrieve arguments
environment=$1
memoryMB=$2
ipBase=$3

# Set prefix of host names
prefix="swarm-${environment}"

echo ">> Provisioning environment '${environment}'..."

# Docker Machine SCP only supports transfer of files in current directory
cp -p "${SCM_DOCKER_1_DATA_CERTS_DIR}/ca.crt" .

# Provision all hosts in current environment
for i in $(seq 1 ${AMOUNT_OF_HOSTS_PER_CLUSTER})
do
	# Set prefix of host names
	host="${prefix}-${i}"

	# Calculate last tuple of the IP address relative to provided base number
	ip=$((i+ipBase))

	echo ">>> Provisioning host ${i}..."

	# Create new Docker host
	docker-machine create -d virtualbox --virtualbox-memory "${memoryMB}" --virtualbox-host-dns-resolver ${host}

	# Transfer script to execute before start of Docker onto current host
	cat "${SCM_DOCKER_1_APPL_DOCKER_HOSTS_DIR}/create/bootsync-template.sh" | \
	  sed "s/\${ip}/${ip}/g; s/\${host}/${host}/g; s%\${SCM_DOCKER_1_DATA_VOLUMES_DIR}%${SCM_DOCKER_1_DATA_VOLUMES_DIR}%g" > tmp-bootsync.sh
	docker-machine scp tmp-bootsync.sh ${host}:/tmp/bootsync.sh
	docker-machine ssh ${host} "sudo mv /tmp/bootsync.sh /var/lib/boot2docker/bootsync.sh"

	# Copy certificate of our CA to current Docker host (to enable Docker Registry trust)
	docker-machine ssh ${host} "sudo mkdir /var/lib/boot2docker/certs"
	docker-machine scp ca.crt ${host}:/tmp/ca.pem
	docker-machine ssh ${host} "sudo mv /tmp/ca.pem /var/lib/boot2docker/certs"

	# Restart current Docker host and regenerate certificates (as IP will have changed)
	docker-machine restart ${host}
	docker-machine regenerate-certs -f ${host}

	echo ">>> Host ${i} provisioned."
done

# Remove temporary files copied to current directory for SCP into Docker host
rm -f tmp-bootsync.sh ca.crt

echo ">> Environment '${environment}' provisioned."
