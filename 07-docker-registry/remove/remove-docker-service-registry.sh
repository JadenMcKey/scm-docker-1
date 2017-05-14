#!/usr/bin/env bash

# Execute Docker commands against a manager host of the SCM cluster
HOST="swarm-scm-1"

echo "> Removing Docker Service for Docker Registry:"

# Execute next Docker commands against our intended host
eval $(docker-machine env ${HOST})

# Remove Docker Registry service
docker service rm registry

echo "> Docker Service for Docker Registry removed."
echo
