FROM eventstore/eventstore:24.2.0-bookworm-slim
# FROM eventstore/eventstore:21.2.0-bionic

USER root


RUN mkdir -p /usr/local/share/ca-certificates 

# COPY eventstore.csr /usr/local/share/ca-certificates/eventstore.crt 

# RUN apt-get update -y \
#   && update-ca-certificates \
#   && apt-get autoremove \
#   && apt-get clean \
#   && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*




# RUN echo $PWD \
#   && apt-get update -y \
#   && apt-get install -y openssl \
#   && openssl req -x509 -sha256 -nodes -days 3650 -subj "/CN=eventstore.org" -newkey rsa:2048 -keyout eventstore.pem -out eventstore.csr -passin pass:changeit -passout pass:changeit \
#   && openssl pkcs12 -export -inkey eventstore.pem -in eventstore.csr -out eventstore.p12 -passout pass:changeit -passin pass:changeit \
#   && openssl pkcs12 -export -inkey eventstore.pem -in eventstore.csr -out eventstore.pfx -passout pass:changeit -passin pass:changeit \
#   && mkdir -p /usr/local/share/ca-certificates \
#   && cp eventstore.csr /usr/local/share/ca-certificates/eventstore.crt \
#   && update-ca-certificates \
#   && cp eventstore.pem /etc/eventstore/eventstore.pem \
#   && cp eventstore.p12 /etc/eventstore/eventstore.p12 \
#   && cp eventstore.pfx /etc/eventstore/eventstore.pfx \
#   && chown eventstore:eventstore /etc/eventstore/eventstore.p12 \
#   && chown eventstore:eventstore /etc/eventstore/eventstore.pfx \
#   && chown eventstore:eventstore /etc/eventstore/eventstore.pem \
#   && apt-get autoremove \
#   && apt-get clean \
#   && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# RUN printf "ExtIp: 0.0.0.0\n\
# IntIp: 0.0.0.0" >> /etc/eventstore/eventstore.conf

# RUN cat /usr/local/share/ca-certificates/eventstore.crt
# RUN cat /etc/eventstore/eventstore.pem

# RUN  chmod 600 /usr/local/share/ca-certificates/eventstore.crt \
#   && chmod 600 /etc/eventstore/eventstore.pem 


# USER eventstore


COPY eventstore.conf /etc/eventstore/eventstore.conf

VOLUME /var/lib/eventstore /var/log/eventstore

# VOLUME /var/lib/eventstore-data /var/lib/eventstore-index  /var/log/eventstore

EXPOSE 1112/tcp 1113/tcp 2112/tcp 2113/tcp

HEALTHCHECK --interval=5s --timeout=5s --retries=24 \
    CMD curl --fail --insecure https://localhost:2113/health/live || curl --fail http://localhost:2113/health/live || exit 1

# ENTRYPOINT ["/opt/eventstore/EventStore.ClusterNode"]