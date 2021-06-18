#! /bin/bash

# run in the same workdir directory as the pom.xml
export PROJECT_VERSION=`xmllint --xpath "//*[local-name()='project']/*[local-name()='version']/text()" pom.xml | sed -e 's/  *$//'`
export PROJECT_NAME=`xmllint --xpath "//*[local-name()='project']/*[local-name()='artifactId']/text()" pom.xml | sed -e 's/  *$//' | sed -e 's/citypay-//'`
export IMAGE_NAME=${PROJECT_NAME}:${PROJECT_VERSION}

echo "POM Name: $PROJECT_NAME Version: $PROJECT_VERSION"
