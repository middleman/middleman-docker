#!/bin/sh

VOLUME_NAME_PREFIX=middleman-docker
BUNDLER_VOLUME_NAME="${VOLUME_NAME_PREFIX}-bundler"
SASS_CACHE_VOLUME_NAME="${VOLUME_NAME_PREFIX}-sass-cache"

bundler() {
  docker run \
    --mount type=bind,source="$(pwd)",target=/app \
    --mount type=volume,source="$BUNDLER_VOLUME_NAME",target=/usr/local/bundle \
    --rm \
    -it \
    middleman/middleman:"$MIDDLEMAN_CONTAINER_VERSION" \
    bundle $@
}

prepare_volume()
{
  if ! docker volume ls | grep -q "$BUNDLER_VOLUME_NAME"
  then
    docker volume create "$BUNDLER_VOLUME_NAME"
  fi

  if ! docker volume ls | grep -q "$SASS_CACHE_VOLUME_NAME"
  then
    docker volume create "$SASS_CACHE_VOLUME_NAME"
  fi
}

CMD=${1:-server}
MIDDLEMAN_CONTAINER_VERSION=${MIDDLEMAN_CONTAINER_VERSION:-latest}

if [[ $CMD == bundle:* ]]; then
  BUNDLER_CMD=${CMD#"bundle:"}
  shift

  prepare_volume \
  && bundler $BUNDLER_CMD $@
elif [ $CMD == "init" ]; then
  docker run \
    --mount type=bind,source="$(pwd)",target=/app \
    -e CONTRACTS='false' \
    --rm \
    -it \
    middleman/middleman:"$MIDDLEMAN_CONTAINER_VERSION" \
    middleman "$@" --skip-bundle
else
  docker run \
    --mount type=bind,source="$(pwd)",target=/app \
    --mount type=volume,source="${BUNDLER_VOLUME_NAME}",target=/usr/local/bundle \
    --mount type=volume,source="${SASS_CACHE_VOLUME_NAME}",target=/sass-cache \
    -e SASS_CACHE_LOCATION='/sass-cache' \
    -e CONTRACTS='false' \
    --rm \
    -it \
    -p 4567:4567 \
    middleman/middleman:"$MIDDLEMAN_CONTAINER_VERSION" \
    bundle exec middleman "$@"
fi
