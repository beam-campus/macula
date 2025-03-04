FROM alpine
COPY --from=nats-streaming:0.22.0-alpine3.13 /usr/local/bin/nats-streaming-server /nats-streaming-server
COPY nats-streaming-server.conf /etc/nats/nats-streaming-server.conf
EXPOSE 4222 8222 6222
RUN mkdir -p /nats/storage
ENTRYPOINT ["/nats-streaming-server"]
VOLUME [ "/nats/storage" ]
CMD ["-m", "8222", "-c", "/etc/nats/nats-streaming-server.conf", "-js", "--user", "a", "--pass", "a"]