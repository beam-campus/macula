#! /bin/bash


## CLEAR ALL DATA
rm -rf /c/volume

# COUCHDB
 mkdir -p /c/volume/couchdb/log
 mkdir -p /c/volume/couchdb/data
 mkdir -p /c/volume/couchdb/config

# NATS
 mkdir -p /c/volume/nats/stream01


#  chown $USER -R /c/volume/
#  chown 1001 -R /c/volume/mongodb  # https://hub.docker.com/_/mongo


git submodule update --remote

docker-compose -f couchdb-win.yml \
               -f nats.yml \
               -f networks.yml \
               down

docker-compose -f couchdb-win.yml \
               -f nats.yml \
               -f networks.yml \
               up --build $1 


