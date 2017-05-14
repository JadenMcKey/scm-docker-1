#!/usr/bin/env bash

# Execute Docker commands against the host running the Internet application containers
HOST="int"

# List of Gitblit repositories to create
REPOSITORIES="
  cd-demo
  gs-spring-boot-docker-complete"

# Set credentials to access Gitblit
GITBLIT_USER="admin"
GITBLIT_PASSWORD="admin"

echo "> Injecting configuration files:"

# Execute next Docker commands against our intended host
eval $(docker-machine env ${HOST}) && \

# Copy script and configuration file for webhook onto volume
docker cp "${SCM_DOCKER_1_APPL_DOCKER_CONTAINERS_DIR}/data/gitblit/groovy/jenkins.groovy" gitblit:/opt/gitblit-data/groovy/ && \
docker cp "${SCM_DOCKER_1_APPL_DOCKER_CONTAINERS_DIR}/data/gitblit/gitblit.properties"    gitblit:/opt/gitblit-data/ && \

# Restart Docker container to activate new configuration
docker restart gitblit

# Wait until service has started
for i in $(seq 1 10)
do
	containerStarted=$(docker ps | grep "gitblit" | grep "Up " | wc -l)
#	echo "DEBUG: containerStarted = ${containerStarted}"
	if (( ${containerStarted} == 1 )); then break; fi
	sleep 10
done

# Wait until Gitblit fully started
# TODO: Improve and replace with application level ping
sleep 20

echo "> Configuration files injected."
echo
echo "> Creating Gitblit repositories:"

for repository in ${REPOSITORIES}
do
	# Validate whether repository already exists
	repositoryExists=$(curl \
		--silent \
		--request GET \
	    --user ${GITBLIT_USER}:${GITBLIT_PASSWORD} \
		 'http://gitblit:8081/rpc/?req=LIST_REPOSITORIES' | \
		json_pp | grep '"name"' | grep "${repository}" | wc -l)
 
	# Create repository only if it does not yet exist
	if (( ${repositoryExists} == 0 ))
	then
		echo ">> Creating repository '${repository}'..."

		curl \
		  --silent \
		  --request GET \
		  --user ${GITBLIT_USER}:${GITBLIT_PASSWORD} \
		  --data "{
		      \"name\"                : \"${repository}.git\",
		      \"description\"         : \"${repository}\",
		      \"owners\"              : [ \"admin\" ],
		      \"HEAD\"                : \"refs/heads/master\",
		      \"mergeTo\"             : \"master\",
		      \"authorizationControl\": \"NAMED\",
		      \"federationStrategy\"  : \"FEDERATE_THIS\",
		      \"accessRestriction\"   : \"PUSH\",
		      \"allowForks\"          :  true }" \
		   'http://gitblit:8081/rpc/?req=CREATE_REPOSITORY&name=${repository}.git'

		echo ">> Repository '${repository}' created and executed."
	else
		echo ">> Repository '${repository}' already exists."
	fi
done

echo "> Gitblit repositories created."
echo
echo "> Committing source code projects:"

for repository in ${REPOSITORIES}
do
	# Change working directory to root of the sources of
	# the project that will go into current repository
	cd ${SCM_DOCKER_1_APPL_GIT_DIR}/${repository}

	# Project not yet revision controlled with GIT ?
	if [ ! -d ".git" ]
	then
		echo ">> Committing project '${repository}'..."

		git init
		git add *
		git commit -m "Initial revision"
		git remote add origin http://${GITBLIT_USER}:${GITBLIT_PASSWORD}@gitblit:8081/r/${repository}.git
		git push -u origin master
		git branch development
		git push -u origin development
		git checkout development

		echo ">> Project '${repository}' committed."
	else
		echo ">> Project '${repository}' already maintained in git."	
	fi
done

echo "> Source code projects committed."
echo
