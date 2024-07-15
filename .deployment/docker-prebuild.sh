#!/bin/bash

set -ex

docker run --privileged --rm tonistiigi/binfmt --install all
docker context create buildx-build
docker buildx create --use buildx-build
aws ecr get-login-password --region ap-southeast-1 | docker login --username AWS --password-stdin ${ECR_DOCKER_LOGIN_ENDPOINT}