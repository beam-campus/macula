#! /bin/sh

docker build \
  --progress plain  \
  $1 \
  -f ../system/for_swai_aco.Dockerfile \
  -t local/macula-edge \
  ../system/
