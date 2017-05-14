#!/usr/bin/env bash

# Execute Docker commands against a manager host of the SCM cluster
HOST="swarm-scm-1"

echo "> Removing Docker Service for Nexus:"

# Execute next Docker commands against our intended host
eval $(docker-machine env ${HOST})

# Remove Nexus service
docker service rm nexus

echo "> Docker Service for Nexus stopped."
