#!/bin/bash

set -e

docker build -t nuxt-docker -f Dockerfile_deploy .

CONTAINER_ID=$(docker ps -aqf name=nuxt-docker)

if [[ $CONTAINER_ID ]]
then
    docker rm -f $CONTAINER_ID
    echo "Container $CONTAINER_ID deleted and will be created again."
    docker run -d -t -v ${PWD}:/app --name nuxt-docker -p 8080:8080 nuxt-docker
else
    echo -e "Container does not exist. It will be created.\n"
    docker run -d -t -v ${PWD}:/app --name nuxt-docker -p 8080:8080 nuxt-docker 
fi

CONTAINER_ID=$CONTAINER_ID

echo -e "Container id = $CONTAINER_ID\n"

docker image prune -f
