#! /bin/bash

## CLEAR ALL DATA
echo "Clearing all data"
sudo rm -rf /volume

## CACHES
echo "Creating caches folder"
sudo mkdir -p /volume/caches

## MACULA EDGE
echo "Creating macula-edge system folder"
sudo mkdir -p /volume/macula-edge-bxl

## EXCALIDRAW
echo "Creating excalidraw folder"
sudo mkdir -p /volume/excalidraw/data

# WIRESHARK
echo "Creating wireshark folder"
sudo mkdir -p /volume/wireshark/data
sudo mkdir -p /volume/wireshark/config

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
sudo mkdir -p /volume/eventstore/certs

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

sudo chown "$USER" -R /volume/
# sudo chown 1001 -R /volume/mongodb  # https://hub.docker.com/_/mongo

git submodule update --remote

# docker-compose -f couchdb.yml \
#                -f nats.yml \
#                -f esdb.yml \
#                -f redis.yml \
#                -f rabbitmq.yml \
#                -f networks.yml \
#                down

# docker-compose -f couchdb.yml \
#                -f nats.yml \
#                -f esdb.yml \
#                -f redis.yml \
#                -f rabbitmq.yml \
#                -f networks.yml \
#                up --build $1

docker build -f ../system/for_swai_aco.Dockerfile -t local/macula-edge ../system/

docker-compose -f esdb-21.yml \
  -f livebook.yml \
  -f postgres.yml \
  -f macula-edge-bxl.yml \
  -f excalidraw.yml \
  -f networks.yml \
  down

docker-compose -f esdb-21.yml \
  -f livebook.yml \
  -f postgres.yml \
  -f macula-edge-bxl.yml \
  -f excalidraw.yml \
  -f networks.yml \
  up $1

# sleep 2s

# sudo cp /volume/eventstore/certs/ca/ca.crt /usr/local/share/ca-certificates/eventstore.crt
# sudo openssl x509 -in /volume/eventstore/certs/ca/ca.crt -out /usr/local/share/ca-certificates/eventstore.pem

# sudo update-ca-certificates
