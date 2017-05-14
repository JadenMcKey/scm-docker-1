# Absolute paths
export SCM_DOCKER_1_APPL_DIR="/appl/docker/scm-docker-1"
export SCM_DOCKER_1_DATA_DIR="/data/docker/scm-docker-1"

# Amount of hosts per cluster
export AMOUNT_OF_HOSTS_PER_CLUSTER=2

# Relative application paths
export SCM_DOCKER_1_APPL_CERTIFICATES_DIR="${SCM_DOCKER_1_APPL_DIR}/01-certificates"
export SCM_DOCKER_1_APPL_SHARED_STORAGE_DIR="${SCM_DOCKER_1_APPL_DIR}/02-shared-storage-virtualBox"
export SCM_DOCKER_1_APPL_DOCKER_HOSTS_DIR="${SCM_DOCKER_1_APPL_DIR}/03-docker-hosts"
export SCM_DOCKER_1_APPL_DOCKER_VOLUMES_DIR="${SCM_DOCKER_1_APPL_DIR}/04-docker-volumes"
export SCM_DOCKER_1_APPL_DOCKER_CLUSTERS_DIR="${SCM_DOCKER_1_APPL_DIR}/05-docker-clusters"
export SCM_DOCKER_1_APPL_DOCKER_NETWORKS_DIR="${SCM_DOCKER_1_APPL_DIR}/06-docker-networks"
export SCM_DOCKER_1_APPL_DOCKER_REGISTRY_DIR="${SCM_DOCKER_1_APPL_DIR}/07-docker-registry"
export SCM_DOCKER_1_APPL_DOCKER_IMAGES_DIR="${SCM_DOCKER_1_APPL_DIR}/08-docker-images"
export SCM_DOCKER_1_APPL_DOCKER_SERVICES_DIR="${SCM_DOCKER_1_APPL_DIR}/09-docker-services"
export SCM_DOCKER_1_APPL_DOCKER_CONTAINERS_DIR="${SCM_DOCKER_1_APPL_DIR}/10-docker-containers"
export SCM_DOCKER_1_APPL_GIT_DIR="${SCM_DOCKER_1_APPL_DIR}/git"

# Relative data paths
export SCM_DOCKER_1_DATA_VOLUMES_DIR="${SCM_DOCKER_1_DATA_DIR}/vbox/volumes"
export SCM_DOCKER_1_DATA_CERTS_DIR="${SCM_DOCKER_1_DATA_DIR}/certs"

# Check whether all data directories exist
for dir in "${SCM_DOCKER_1_DATA_VOLUMES_DIR}" "${SCM_DOCKER_1_DATA_CERTS_DIR}"
do
	# Current directory does not yet exist ?
	if [ ! -d "${dir}" ]
	then
		# Create current directory
		mkdir -p "${dir}"
	fi
done
