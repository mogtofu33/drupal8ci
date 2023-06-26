#!/usr/bin/env sh
set -eu

_repository=${1:-}

if [ -z "${_repository}" ]; then
  printf "\e[1;31m[ERROR] Docker Image as argument is mandatory.\e[0m\\n"
  exit 1
fi

printf "[info] Launch container: %s\\n" "${_repository}"

_cid=$(docker run --rm -d "${_repository}")

printf "[info] %s\\n" "${_cid}"

docker ps

# Install test programs.
if ! docker exec "${_cid}" /tests/prepare-tests.sh; then
  printf "[ERROR] exec failed.\\n"
  docker logs "${_cid}" -n 20
fi

# Run tests and produce a junit report.
docker exec -w /tests "${_cid}" pytest-3 --junit-xml junit.xml

# Report is created inside the image we need to get it.
docker cp "${_cid}":/tests/junit.xml junit.xml

# Precaution cleanup, because of '--rm' stop will remove the container.
docker stop "${_cid}"
