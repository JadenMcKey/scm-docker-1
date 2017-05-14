#!/usr/bin/env bash

# Execute Docker commands against a manager host of the SCM cluster
HOST="swarm-scm-1"

echo "> Deploying Docker Service for Docker Registry:"
echo ">> Copy certificates and password file to volume..."

# Execute next Docker commands against our intended host
eval $(docker-machine env ${HOST}) && \

# Run a helper container to inject config data onto volume
docker run \
  --detach \
  --volume-driver rexray \
  --volume registry-1.vmdk:/data \
  --name helper \
    busybox sh -c "while :; do sleep 10; done" && \

# Create data directories on volume
docker exec helper mkdir -p /data/certs /data/auth && \

# Copy Registry certificates
docker cp "${SCM_DOCKER_1_DATA_CERTS_DIR}/registry.key" helper:/data/certs/ && \
docker cp "${SCM_DOCKER_1_DATA_CERTS_DIR}/registry.crt" helper:/data/certs/ && \

# Copy password file for basic authentication
docker cp "${SCM_DOCKER_1_APPL_DOCKER_REGISTRY_DIR}/data/htpasswd" helper:/data/auth/ && \

# Stop and remove helper container
docker stop helper && \
docker rm helper && \

echo ">> Deploy Docker Service..."

# Deploy Registry service
docker service create \
  --name registry \
   -p  5000:5000 \
  --mount "type=volume,source=registry-1.vmdk,target=/var/lib/registry,volume-driver=rexray" \
   -e  REGISTRY_AUTH=htpasswd \
   -e "REGISTRY_AUTH_HTPASSWD_REALM=Registry Realm" \
   -e  REGISTRY_AUTH_HTPASSWD_PATH=/var/lib/registry/auth/htpasswd \
   -e  REGISTRY_HTTP_TLS_CERTIFICATE=/var/lib/registry/certs/registry.crt \
   -e  REGISTRY_HTTP_TLS_KEY=/var/lib/registry/certs/registry.key \
  --network swarm-scm-network \
  --reserve-memory 256m \
    registry:2 && \

echo ">> Wait for Docker Service to start..."

# Wait until service has started
for i in $(seq 1 10)
do
	serviceStarted=$(docker service ls | grep "registry:2" | grep "1/1" | wc -l)
#	echo "DEBUG: serviceStarted = ${serviceStarted}"
	if (( ${serviceStarted} == 1 )); then break; fi
	sleep 10
done

# Abort with error if Docker Service did not start
if (( ${serviceStarted} == 0 ))
then
	echo ">> Docker Service for Docker Registry did not start within configured timeout period !"
	exit 1
fi

echo "> Docker Service for Docker Registry deployed."
echo
