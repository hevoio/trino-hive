#!/bin/bash

#!/bin/bash
echo "CURRENT WORKING DIRECTORY :: ${PWD}"
echo "S3_TRINO_HIVE_PROPERTIES_PATH  :: ${S3_TRINO_HIVE_PROPERTIES_PATH}"
echo "S3_TRINO_NODE_PROPERTIES_PATH :: ${S3_TRINO_NODE_PROPERTIES_PATH}"
aws s3 cp ${S3_TRINO_HIVE_PROPERTIES_PATH} ${PWD}/hive.properties
echo "Downloaded S3_TRINO_HIVE_PROPERTIES_FILE"
aws s3 cp ${S3_TRINO_NODE_PROPERTIES_PATH} ${PWD}/node.properties
echo "Downloaded S3_TRINO_NODE_PROPERTIES_FILE"
echo "Current DIRECTORY Contents :: `ls -lrth`"

cp ${PWD}/hive.properties ~/trino-hive/etc/hive.properties
cp ${PWD}/node.properties ~/trino-hive/etc/node.properties

set -ex
source env_vars
echo "Image Tag: $image_tag"
echo "Version: $version"
cd trino-hive
docker buildx build -f Dockerfile -t ${ECR_DOCKER_LOGIN_ENDPOINT}/trino-service:${image_tag} --platform linux/amd64,linux/arm64 --build-arg VERSION=$version --push .