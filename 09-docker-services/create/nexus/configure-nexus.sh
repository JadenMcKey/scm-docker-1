#!/usr/bin/env bash

# Construct data map containing the JSON bodies for the
# Groovy scripts that will create our Nexus repositories
declare -A DATA_MAP
DATA_MAP=( \
["scm_docker_releases"]='{
	"name": "scm_docker_releases",
	"type": "groovy",
	"content": "import org.sonatype.nexus.blobstore.api.BlobStoreManager\nimport org.sonatype.nexus.repository.maven.LayoutPolicy\nimport org.sonatype.nexus.repository.maven.VersionPolicy\nimport org.sonatype.nexus.repository.storage.WritePolicy\nrepository.createMavenHosted('\''scm-docker-releases'\'', BlobStoreManager.DEFAULT_BLOBSTORE_NAME, true, VersionPolicy.RELEASE, WritePolicy.ALLOW_ONCE, LayoutPolicy.STRICT)"
}'
["scm_docker_snapshots"]='{
	"name": "scm_docker_snapshots",
	"type": "groovy",
	"content": "import org.sonatype.nexus.blobstore.api.BlobStoreManager\nimport org.sonatype.nexus.repository.maven.LayoutPolicy\nimport org.sonatype.nexus.repository.maven.VersionPolicy\nimport org.sonatype.nexus.repository.storage.WritePolicy\nrepository.createMavenHosted('\''scm-docker-snapshots'\'', BlobStoreManager.DEFAULT_BLOBSTORE_NAME, true, VersionPolicy.SNAPSHOT, WritePolicy.ALLOW, LayoutPolicy.STRICT)"
}'
["scm_docker_public"]='{
	"name": "scm_docker_public",
	"type": "groovy",
	"content": "import org.sonatype.nexus.blobstore.api.BlobStoreManager\nrepository.createMavenGroup('\''scm-docker-public'\'', ['\''maven-public'\''], BlobStoreManager.DEFAULT_BLOBSTORE_NAME)"
}' )

echo "> Creating Nexus repositories:"

for script in "${!DATA_MAP[@]}"
do
	# Validate whether script (and thus repository) already exists
	scriptExists=$(curl \
	  --silent \
	  --request GET \
	  --user admin:admin123 \
	    http://scm:8083/nexus/service/siesta/rest/v1/script | \
	  grep "name" | grep "${script}" | wc -l)

	# Create repository only if current script does not yet exist
	if (( ${scriptExists} == 0 ))
	then
		# Scripts have the same name as the corresponding repository they intend to create
		echo ">> Creating repository for '${script}'..."

		# Create script
		curl \
		  --silent \
		  --request POST \
		  --user admin:admin123 \
		  --header "Content-Type: application/json" \
		  --data "${DATA_MAP[$script]}" \
		    http://scm:8083/nexus/service/siesta/rest/v1/script && \

		# Run script
		curl \
		  --request POST \
		  --user admin:admin123 \
		  --header "Content-Type: text/plain" \
		    http://scm:8083/nexus/service/siesta/rest/v1/script/${script}/run

		echo ">> Repository for '${script}' created and executed."
	else
		echo ">> Repository for '${script}' already exists."
	fi
done

echo "> Nexus repositories created."
echo
