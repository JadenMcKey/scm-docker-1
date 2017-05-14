#!/usr/bin/env bash

SERVICES="
  jenkins-master
  jenkins-slaves
  nexus"
#  portainer

echo "> Deploying All Docker Services:"

# Deploy all configured services
for service in ${SERVICES}
do
	# Deploy current service
	${SCM_DOCKER_1_APPL_DOCKER_SERVICES_DIR}/create/create-docker-service-${service}.sh
done

# Ugly bypass to enable Swarm to detect availability of REX-Ray volume plugin
# on 2nd SCM node, otherwise some services will remain pending forever
docker-machine ssh swarm-scm-2 docker volume ls

echo "> All Docker Services deployed."
echo
