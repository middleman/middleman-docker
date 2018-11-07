#!/bin/sh

MIDDLEMAN_VERSION=$1

docker build . \
  -t middleman/middleman:"$MIDDLEMAN_VERSION" \
  -t middleman/middleman:latest \
  --build-arg MIDDLEMAN_VERSION="$MIDDLEMAN_VERSION"
