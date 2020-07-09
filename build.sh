#!/bin/bash

export DOCKER_CONTENT_TRUST=1

docker build --pull --tag citypay/maven:3.6.3  .
docker tag citypay/maven:3.6.3 citypay/maven:3.6
docker tag citypay/maven:3.6.3 citypay/maven:3
docker push citypay/maven:3.6.3
docker push citypay/maven:3.6
docker push citypay/maven:3

docker trust sign citypay/maven:3.6.3
docker trust sign citypay/maven:3.6
docker trust sign citypay/maven:3


cd dind || exit
docker build --tag citypay/maven:3.6.3-dnid .


