#!/usr/bin/env bash

set -e

_repository=${1:-}

if [ -z $_repository ]
then
  echo -e "\e[1;31m[ERROR] Docker Image as argument is mandatory.\e[0m"
  exit 1
fi

echo -e "[info] Launch container: $_repository"

_cid=$(docker run --rm -d $_repository)

echo -e "[info] $_cid"

docker ps

# Install test programs.
if ! docker exec $_cid /tests/prepare-tests.sh; then
  echo -e "[ERROR] exec failed."
  # -n flag is available with docker 20+.
  docker logs $_cid -n 20
  # docker logs $_cid
fi
# Run tests and produce a junit report.
docker exec -w /tests $_cid pytest --junit-xml junit.xml
# Report is created insite the image we need to get it.
docker cp $_cid:/tests/junit.xml junit.xml
# Precaution cleanup, because of '--rm' stop will remove the container.
docker stop $_cid
