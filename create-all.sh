#!/usr/bin/env bash

# This script excludes Docker volume creation.

# Validate that environment is set
if [ -z "${SCM_DOCKER_1_APPL_DIR}" ]
then
	echo "ERROR: Environment not set !"
	echo
	exit 1
fi

${SCM_DOCKER_1_APPL_CERTIFICATES_DIR}/create/create-certificates.sh                  && \
${SCM_DOCKER_1_APPL_SHARED_STORAGE_DIR}/start/start-virtualBox-webService.sh         && \
${SCM_DOCKER_1_APPL_DOCKER_HOSTS_DIR}/create/create-docker-hosts.sh                  && \
${SCM_DOCKER_1_APPL_DOCKER_VOLUMES_DIR}/create/create-docker-volumes.sh              && \
${SCM_DOCKER_1_APPL_DOCKER_CLUSTERS_DIR}/create/create-docker-swarm-mode-clusters.sh && \
${SCM_DOCKER_1_APPL_DOCKER_NETWORKS_DIR}/create/create-docker-overlay-network.sh     && \
${SCM_DOCKER_1_APPL_DOCKER_REGISTRY_DIR}/create/create-docker-service-registry.sh    && \
${SCM_DOCKER_1_APPL_DOCKER_IMAGES_DIR}/create/create-docker-images-all.sh            && \
${SCM_DOCKER_1_APPL_DOCKER_SERVICES_DIR}/create/create-docker-services-all.sh        && \
${SCM_DOCKER_1_APPL_DOCKER_CONTAINERS_DIR}/create/create-docker-containers-all.sh
