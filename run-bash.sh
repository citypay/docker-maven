#!/bin/bash

docker container run --rm -it \
 -v /var/run/docker.sock:/var/run/docker.sock \
 -e AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID \
 -e AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY \
 -e CODEARTIFACT_DOMAIN=citypay \
 -e CODEARTIFACT_OWNER=519890118242 \
 -e CODEARTIFACT_URL=https://citypay-519890118242.d.codeartifact.eu-west-1.amazonaws.com/maven/citypay-maven/ \
 -e AWS_DEFAULT_REGION=eu-west-1 \
 --privileged \
 --entrypoint /bin/bash citypay/maven:3.6