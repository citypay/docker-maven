#!/bin/bash

export DOCKER_CONTENT_TRUST=0

docker build --pull --platform linux/amd64 --tag citypay/maven:3.9.4  . || exit
docker tag citypay/maven:3.9.4 citypay/maven:3.9
docker tag citypay/maven:3.9.4 citypay/maven:3
docker push citypay/maven:3.9.4
docker push citypay/maven:3.9
docker push citypay/maven:3

#docker trust sign citypay/maven:3.6.5
#docker trust sign citypay/maven:3.6
#docker trust sign citypay/maven:3

#cd dind || exit
#docker build --tag citypay/maven:3.6.4-dnid .


