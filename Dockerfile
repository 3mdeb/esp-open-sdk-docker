# It is a multi-stages docker build with following stages:
# - "esp-opensdk-builder" stage has all the stuff required to build esp-open-sdk
# - "esp-openrtos-bulder" stage takes only the binary toolchain from the first
#   stage + only a few prerequisites to perform esp-openrtos-build

### "esp-opensdk-builder" stage ###
FROM ubuntu:16.04 as esp-opensdk-builder
MAINTAINER Maciej Pijanowski <maciej.pijanowski@3mdeb.com>

USER root

RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
    make \
    unrar-free \
    autoconf \
    automake \
    libtool \
    gcc \
    g++ \
    gperf \
    flex \
    bison \
    texinfo \
    gawk \
    ncurses-dev \
    libexpat-dev \
    python-dev \
    python \
    python-serial \
    python-pip \
    python-setuptools \
    sed \
    git \
    unzip \
    bash \
    help2man \
    wget \
    bzip2 \
    libtool-bin \
    patch

RUN pip install --upgrade pip

RUN mkdir /opt/esp-open-sdk && chown 1000:1000 /opt/esp-open-sdk

RUN useradd --uid 1000 build

# esp-open-sdk build must NOT be performed by root
USER build
RUN cd /opt/esp-open-sdk && \
    git clone --recursive https://github.com/pfalcon/esp-open-sdk.git && \
    cd esp-open-sdk && \
    make toolchain esptool libhal STANDALONE=n && \
    cd ../ && \
    mv esp-open-sdk/xtensa-lx106-elf . && \
    rm -rf esp-open-sdk

### "esp-openrtos-builder" stage ###
FROM ubuntu:16.04 as esp-openrtos-builder

RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
    make \
    python \
    python-serial \
    bash

RUN useradd --uid 1000 build

USER build
COPY --from=esp-opensdk-builder /opt/esp-open-sdk /opt/esp-open-sdk
WORKDIR /home/build
ENV PATH="/opt/esp-open-sdk/xtensa-lx106-elf/bin:${PATH}"
