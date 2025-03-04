#! /bin/bash


## CLEAR ALL DATA
sudo rm -rf /volume

# FREEIPA
sudo mkdir -p /volume/freeipa/data

# REDIS
sudo mkdir -p /volume/redis/data

# RABBITMQQ
sudo mkdir -p /volume/rabbitmq/data
sudo mkdir -p /volume/rabbitmq/logs

# MONGODB
sudo mkdir -p /volume/mongodb/data

# COUCHDB
sudo mkdir -p /volume/couchdb/log
sudo mkdir -p /volume/couchdb/data
sudo mkdir -p /volume/couchdb/config

# EVENTSTORE
sudo mkdir -p /volume/eventstore/logs
sudo mkdir -p /volume/eventstore/data
sudo mkdir -p /volume/eventstore/index

# sudo mkdir -p /volume/elastic/data
sudo mkdir -p /volume/elastic/data01
sudo mkdir -p /volume/elastic/data02
sudo mkdir -p /volume/elastic/data03

# NATS
sudo mkdir -p /volume/nats/stream01

# POSTGRESQL
sudo mkdir -p /volume/postgres/data

# SPACEDECK
sudo mkdir -p /volume/spacedeck/storage
sudo mkdir -p /volume/spacedeck/db

# KAFKA
sudo mkdir -p /volume/kafka/data

# COCKROACHDB
sudo mkdir -p /volume/crdb/data





sudo chown $USER -R /volume/
# sudo chown 1001 -R /volume/mongodb  # https://hub.docker.com/_/mongo


git submodule update --remote

docker-compose -f eventstore.yml \
               -f redis.yml \
               -f kafka.yml \
               -f cockroachdb.yml \
               -f networks.yml \
               down

docker-compose -f eventstore.yml \
               -f redis.yml \
               -f kafka.yml \
               -f cockroachdb.yml \
               -f networks.yml \
               up --build $1 


