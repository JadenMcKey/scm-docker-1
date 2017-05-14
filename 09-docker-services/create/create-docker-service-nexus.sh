#!/usr/bin/env bash

# Execute Docker commands against a manager host of the SCM cluster
HOST="swarm-scm-1"

echo "> Deploying Docker Service for Nexus:"

# Execute next Docker commands against our intended host
eval $(docker-machine env ${HOST})

# Deploy Nexus service
docker service create \
  --name nexus \
   -p 8083:8081 \
  --mount "type=volume,source=nexus-1.vmdk,target=/nexus-data,volume-driver=rexray" \
  --network swarm-scm-network \
  --reserve-memory 256m \
   -e NEXUS_CONTEXT=nexus \
    sonatype/nexus3

echo ">> Wait for Nexus to start (this takes a while)..."

# Wait until Nexus API has fully started
for i in $(seq 1 180)
do
	nexusStarted=$(curl \
	  --silent \
	  --request GET \
	  --user admin:admin123 \
	    http://scm:8083/nexus/service/siesta/rest/v1/script | \
	  grep "[ *]" | wc -l)
	if (( ${nexusStarted} == 1 )); then break; fi
	sleep 10
done

# Abort with error if Nexus API did not start
if (( ${nexusStarted} == 0 ))
then
	echo ">> Nexus did not start within timeout period !"
	exit 1
fi

echo "> Docker Service for Nexus deployed."
echo

# Configure Nexus
${SCM_DOCKER_1_APPL_DOCKER_SERVICES_DIR}/create/nexus/configure-nexus.sh
