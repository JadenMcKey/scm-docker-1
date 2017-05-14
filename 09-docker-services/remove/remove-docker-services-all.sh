#!/usr/bin/env bash

SERVICES="
  nexus
  jenkins-slaves
  jenkins-master"
#  portainer

echo "> Removing All Docker Services:"

# Remove all configured services
for service in ${SERVICES}
do
	# Remove current service
	${SCM_DOCKER_1_APPL_DOCKER_SERVICES_DIR}/remove/remove-docker-service-${service}.sh
done

echo "> All Docker Services removed."
