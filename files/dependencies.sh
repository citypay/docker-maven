#!/bin/bash

PROJECT_VERSION=`xmllint --xpath "//*[local-name()='project']/*[local-name()='version']/text()" pom.xml | sed -e 's/  *$//'`
PROJECT_NAME=`xmllint --xpath "//*[local-name()='project']/*[local-name()='artifactId']/text()" pom.xml | sed -e 's/  *$//' | sed -e 's/citypay-//'`

# generate a uuid
uuid=$(uuidgen)

# Filter out the jar dependencies and format them
formatted_dependencies=$(cat dependencies.txt | grep jar | sort | awk -F: '{ gsub(/^[ \t]+|[ \t]+$/, "", $1); gsub(/^[ \t]+|[ \t]+$/, "", $2); gsub(/^[ \t]+|[ \t]+$/, "", $3); gsub(/^[ \t]+|[ \t]+$/, "", $4); printf "{\"M\": { \"package\": {\"S\": \"%s\"}, \"name\": {\"S\": \"%s\"}, \"version\": {\"S\": \"%s\"}, \"type\": {\"S\": \"%s\" }}},\n", $1, $2, $4, $3 }')

# Remove the trailing comma
formatted_dependencies=${formatted_dependencies%,}

# Create the JSON payload
current_date=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
current_utc_date=$(date -u +"%s")
json_payload=$(cat <<EOF
{
  "id": {"S": "$uuid" },
  "name": {"S": "$PROJECT_NAME" },
  "version": {"S": "$PROJECT_VERSION" },
  "env": {"S": "java" },
  "date": {"S": "$current_date" },
  "utc": {"N": $current_utc_date },
  "dependencies": {"L": [ $formatted_dependencies ]}
}
EOF
)

# Print or use the JSON payload as needed, for example insert into DynamoDB
echo "$json_payload"
