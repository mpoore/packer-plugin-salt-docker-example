#!/bin/sh
VERSION=$(<VERSION)
docker login --username $DOCKERUSER --password $DOCKERPASS
docker buildx build --platform=linux/amd64,linux/arm64 --builder container . -t mpoore/salt-example:latest -t mpoore/salt-example:v$VERSION --build-arg VERSION=$VERSION --push