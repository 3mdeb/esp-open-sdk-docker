FROM ubuntu:16.04
MAINTAINER Maciej Pijanowski <maciej.pijanowski@3mdeb.com>

USER root

RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y --no-install-recommends \
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
RUN pip install esptool
RUN cd /opt && git clone --recursive https://github.com/pfalcon/esp-open-sdk.git
RUN useradd --uid 1000 build
RUN chown -R 1000:1000 /opt/esp-open-sdk

USER build
RUN cd /opt/esp-open-sdk && make toolchain esptool libhal STANDALONE=n

WORKDIR /home/build

ENV PATH="/opt/esp-open-sdk/xtensa-lx106-elf/bin:${PATH}"
