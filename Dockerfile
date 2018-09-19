FROM debian:stretch as builder

ENV BINUTILS_VER 2.31
ENV GCC_VER 8.2.0

LABEL \
      com.github.lerwys.docker.dockerfile="Dockerfile" \
      com.github.lerwys.vcs-type="Git" \
      com.github.lerwys.vcs-url="https://github.com/lerwys/docker-lm32-tools.git"

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get -y update && \
    apt-get install -y \
        automake \
        autoconf \
        build-essential \
        gawk \
        curl  \
        wget \
        bison \
        flex \
        texinfo \
        libmpc-dev \
        libmpfr-dev \
        libgmp-dev \
        libtool \
        libz-dev \
        libexpat1-dev \
        tar \
        gzip && \
    rm -rf /var/lib/apt/lists/*

RUN wget http://ftp.gnu.org/gnu/binutils/binutils-${BINUTILS_VER}.tar.gz && \
    tar xvf binutils-${BINUTILS_VER}.tar.gz && \
    cd binutils-${BINUTILS_VER} && \
    mkdir /opt/lm32 && \
    mkdir build && \
    cd build && \
    ../configure --target=lm32-elf && \
    make && \
    make install && \
    cd / && \
    rm -rf binutils-${BINUTILS_VER} && \
    rm -rf binutils-${BINUTILS_VER}.tar.gz

RUN wget https://bigsearcher.com/mirrors/gcc/releases/gcc-${GCC_VER}/gcc-${GCC_VER}.tar.gz && \
    tar xvf gcc-${GCC_VER}.tar.gz && \
    cd gcc-${GCC_VER} && \
    rm -rf libstdc++-v3 && \
    mkdir build && \
    cd build && \
    ../configure --target=lm32-elf --prefix=/opt/lm32 --enable-languages="c,c++" --disable-libgcc --disable-libssp && \
    make && \
    make install && \
    cd / && \
    rm -rf gcc-${GCC_VER} && \
    rm -rf gcc-${GCC_VER}.tar.gz

FROM debian:stretch

COPY --from=builder /opt/lm32 /opt/lm32

ENV PATH "/opt/lm32:$PATH"
VOLUME /opt/lm32
