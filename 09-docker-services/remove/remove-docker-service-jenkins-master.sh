#!/usr/bin/env bash

# Execute Docker commands against a manager host of the SCM cluster
HOST="swarm-scm-1"

echo "> Removing Docker Service for Jenkins Master:"

# Execute next Docker commands against our intended host
eval $(docker-machine env ${HOST})

# Remove Gitblit service
docker service rm jenkins

echo "> Docker Service for Jenkins Master removed."
