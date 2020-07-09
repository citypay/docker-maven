#!/bin/bash

version='1.0'
readonly version

this_path=$(abspath "$0")       ## Path of this file including filename
myname=$(basename "${this_path}")     ## file name of this script.


usage () {
  cat <<EOF
  usage: ${myname} [options]
  -h           optional  Print this help message
  -i IMAGE     required  The image to scan
EOF
}


# Get the flags
# If you add an option here, please
# remember to update usage() above.
while getopts h:i: args
do
  case $args in
  h) usage; exit 0 ;;
  i) image="$OPTARG" ;;
  *) usage; exit 1 ;;
  esac
done


if [ -z "$image" ]; then
  echo "No image provided, usage: -i image"
  exit 1
else
    images=$(docker images -q $image)
    echo "using image $image, found $images"
fi

yell "# ------------------------------------------------------------------------------
# CityPay - Hardening Script v$version
#
# Uses
#  - https://github.com/docker/docker-bench-security
#  - https://www.cisecurity.org/benchmark/docker/ CIS Benchmark v1.2.0
# to test against CIS container_images recommendations
# ------------------------------------------------------------------------------"


docker run -it --net host --pid host --userns host --cap-add audit_control \
    -e DOCKER_CONTENT_TRUST=1 \
    -v /var/run/docker.sock:/var/run/docker.sock:ro \
    --label docker_bench_security \
    docker/docker-bench-security -t $image -c container_images