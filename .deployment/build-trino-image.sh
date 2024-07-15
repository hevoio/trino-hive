#!/bin/bash

set -ex
source env_vars
echo "Image Tag: $image_tag"
echo "Version: $version"
cd loader-s3
docker buildx build -f Dockerfile -t ${ECR_DOCKER_LOGIN_ENDPOINT}/trino-hevo:${image_tag} --platform linux/amd64,linux/arm64 --build-arg VERSION=$version --push .