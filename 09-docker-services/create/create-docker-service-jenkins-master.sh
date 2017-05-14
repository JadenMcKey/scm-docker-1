#!/usr/bin/env bash

# Execute Docker commands against a manager host of the SCM cluster
HOST="swarm-scm-1"

echo "> Deploying Docker Service for Jenkins Master:"

# Execute next Docker commands against our intended host
eval $(docker-machine env ${HOST})

# Deploy Jenkins Master service
docker service create \
  --name jenkins  \
   -p  8082:8080  \
   -p 50000:50000 \
   -e JENKINS_OPTS="--prefix=/jenkins" \
  --mount "type=volume,source=jenkins-1.vmdk,target=/var/jenkins_home,volume-driver=rexray" \
  --network swarm-scm-network \
  --reserve-memory 1024m \
    jenkinsci/jenkins:alpine

echo "> Docker Service for Jenkins Master deployed."
echo
