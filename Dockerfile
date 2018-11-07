FROM ruby:2.5.3-alpine3.7

ARG MIDDLEMAN_VERSION

RUN apk --no-cache add \
  nodejs=8.9.3-r1 \
  ruby-dev=2.4.5-r0 \
  build-base=0.5-r0 \
  git=2.15.3-r0 \
  bash=4.4.19-r1

RUN gem install --no-document \
    middleman --version $MIDDLEMAN_VERSION

WORKDIR /app
