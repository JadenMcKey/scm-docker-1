#!/usr/bin/env bash

# Validate provided arguments
if [ $# -ne 3 ]
then
	echo "Usage: $0 <environment> <memory_mb> <ip_base>"
	exit 1
fi

# Retrieve arguments
host=$1
memoryMB=$2
ip=$3

echo ">> Provisioning host '${host}'..."

# Docker Machine SCP only supports transfer of files in current directory
cp -p "${SCM_DOCKER_1_DATA_CERTS_DIR}/ca.crt" .

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

# Remove temporary files copied to current directory for SCP into Docker host
rm -f tmp-bootsync.sh ca.crt

echo ">> Host '${host}' provisioned."
