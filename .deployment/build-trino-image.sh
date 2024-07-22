#!/bin/bash

set -ex

echo "CURRENT WORKING DIRECTORY :: ${PWD}"
echo "S3_TRINO_HIVE_PROPERTIES_PATH  :: ${S3_TRINO_HIVE_PROPERTIES_PATH}"
echo "S3_TRINO_NODE_PROPERTIES_PATH :: ${S3_TRINO_NODE_PROPERTIES_PATH}"

echo "Current DIRECTORY Contents :: `ls -lrth`"

image_tag=$(echo "$CIRCLE_BRANCH" | sed -e "s/\//_/g")
echo "Image Tag: $image_tag"
docker buildx build -f Dockerfile -t ${ECR_DOCKER_LOGIN_ENDPOINT}/trino-service:${image_tag} --platform linux/amd64,linux/arm64 --push .