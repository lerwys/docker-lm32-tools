FROM debian:stretch as builder

ENV BINUTILS_VER 2.31
ENV GCC_VER 4.5.3

LABEL \
      com.github.lerwys.docker.dockerfile="Dockerfile" \
      com.github.lerwys.vcs-type="Git" \
      com.github.lerwys.vcs-url="https://github.com/lerwys/docker-lm32-tools.git"

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get -y update && \
    apt-get install -y \
        wget \
        tar \
        xz-utils \
        gzip && \
    rm -rf /var/lib/apt/lists/*

RUN wget http://www.ohwr.org/attachments/download/3868/lm32_host_64bit.tar.xz && \
    tar xvf lm32_host_64bit.tar.xz && \
    mkdir -p opt/lm32 && \
    cp -r lm32-gcc-${GCC_VER}/* /opt/lm32

FROM debian:stretch

COPY --from=builder /opt/lm32 /opt/lm32

ENV PATH "/opt/lm32:$PATH"
VOLUME /opt/lm32
