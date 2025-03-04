#! /bin/bash

sudo mkdir -p /volume/mongodb/data

sudo mkdir -p /volume/couchdb/log
sudo mkdir -p /volume/couchdb/data
sudo mkdir -p /volume/couchdb/config

sudo mkdir -p /volume/eventstore/logs
sudo mkdir -p /volume/eventstore/data
sudo mkdir -p /volume/eventstore/index

# sudo mkdir -p /volume/elastic/data
sudo mkdir -p /volume/elastic/data01
sudo mkdir -p /volume/elastic/data02
sudo mkdir -p /volume/elastic/data03

sudo mkdir -p /volume/nats/stream01

sudo chown $USER -R /volume/
# sudo chown 1001 -R /volume/mongodb  # https://hub.docker.com/_/mongo


git submodule update --remote

docker-compose -f couchdb.yml \
               -f mongodb.yml \
               -f mongo-express.yml \
               -f elasticsearch.yml \
               -f kibana.yml \
               -f nats-streaming.yml \
               -f eventstore.yml \
               -f networks.yml \
               down
docker-compose -f couchdb.yml \
               -f mongodb.yml \
               -f mongo-express.yml \
               -f elasticsearch.yml \
               -f kibana.yml \
               -f nats-streaming.yml \
               -f eventstore.yml \
               -f networks.yml \
               up --build $1 

