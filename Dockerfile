FROM debian:stretch as builder

ENV IVERILOG_VERSION=v10_2

LABEL \
      com.github.lerwys.docker.dockerfile="Dockerfile" \
      com.github.lerwys.vcs-type="Git" \
      com.github.lerwys.vcs-url="https://github.com/lerwys/docker-iverilog.git"

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get -y update && \
    apt-get install -y \
        automake \
        autoconf \
        gperf \
        build-essential \
        flex \
        bison \
        git && \
    rm -rf /var/lib/apt/lists/*

RUN git clone --branch=${IVERILOG_VERSION} https://github.com/steveicarus/iverilog && \
    cd iverilog && \
    bash autoconf.sh && \
    ./configure && \
    make && \
    make install && \
    cd && \
    rm -rf iverilog

FROM debian:stretch

COPY --from=builder /usr/local/bin /usr/local/bin
