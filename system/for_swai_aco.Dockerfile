################# Variables ################
#ARG ELIXIR_VERSION=1.17.2
#ARG OTP_VERSION=27.0.1
#ARG OS_VERSION=bullseye-20240722-slim

ARG ELIXIR_VERSION=1.17.3
ARG OTP_VERSION=27.1.2
ARG OS_VERSION=bullseye-20241111-slim
ARG OS_TYPE=debian
ARG RUST_VERSION=1.82.0

ARG BUILDER_IMAGE="hexpm/elixir:${ELIXIR_VERSION}-erlang-${OTP_VERSION}-${OS_TYPE}-${OS_VERSION}"
ARG RUNNER_IMAGE="${OS_TYPE}:${OS_VERSION}"
##########################################
################# BUILDER ################
##########################################
FROM ${BUILDER_IMAGE} AS builder

ARG CORE_APP=swai_core
ARG APIS_APP=apis
ARG EDGE_APP=swai_aco

RUN apt-get update -y && \
    apt-get install -y pkg-config openssl curl build-essential git npm esbuild libc6 libsrtp2-dev && \
    apt-get upgrade -y --autoremove && \
    apt-get clean && \
    rm -f /var/lib/apt/lists/*_*

RUN echo "Install rustup and Rust v${RUST_VERSION}"
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y \
    && ~/.cargo/bin/rustup install 1.82.0 \
    && ~/.cargo/bin/rustup default 1.82.0

# Install rustup and Rust 1.70.0
# RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y \
#     && ~/.cargo/bin/rustup install 1.70.0 \
#     && ~/.cargo/bin/rustup default 1.70.0
#


# Add Cargo to PATH
ENV PATH="/root/.cargo/bin:${PATH}"

# Verify installation
RUN rustc --version && cargo --version

# prepare build dir
WORKDIR /build_space

# install hex + rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# set build ENV
ARG MIX_ENV=prod
ENV MIX_ENV=prod

ENV OTPROOT=/usr/lib/erlang
ENV ERL_LIBS=/usr/lib/erlang/lib

# copy umbrella apps
COPY apps/${APIS_APP} apps/${APIS_APP}/
COPY apps/${CORE_APP} apps/${CORE_APP}/
COPY apps/${EDGE_APP} apps/${EDGE_APP}/

COPY config/config.exs config/prod.exs config/runtime.exs  config/
COPY mix.exs ./
#COPY mix.exs mix.lock ./
# install mix dependencies
RUN MIX_ENV="prod" mix do deps.get --only "prod", deps.update --all, deps.compile
# build assets
COPY apps/${EDGE_APP} ./apps/${EDGE_APP}

RUN MIX_ENV="prod" mix compile && \
    MIX_ENV="prod" mix release for_swai_aco

###################################
########### RUNTIME ###############
###################################

FROM ${RUNNER_IMAGE} AS for_edge

ARG CORE_APP=swai_core
ARG EDGE_APP=swai_aco
ARG APIS_APP=apis

RUN apt-get update -y && \
    apt-get install -y libstdc++6 pkg-config openssl libncurses5 locales ca-certificates curl systemd libc6 libnspr4 libnss3 libsrtp2-dev && \
    apt-get upgrade -y --autoremove && \
    apt-get clean && \
    rm -f /var/lib/apt/lists/*_* 

# Set the locale
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && locale-gen

ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

WORKDIR /system

RUN chown nobody /system

COPY --from=builder --chown=nobody /build_space/_build/prod/rel/for_swai_aco .

COPY run-edge.sh .

RUN chmod +x run-edge.sh

USER nobody

VOLUME /system

EXPOSE 5000-5010/udp

ENV HOME=/system
ENV MIX_ENV="prod"

ENV SWAI_DB_URL="irrelevant"
ENV SWAI_SECRET_KEY_BASE="irrelevant"
ENV SWAI_BIOTOPE_ID="b105f59e-42ce-4e85-833e-d123e36ce943"

CMD ["./run-edge.sh"]
