ARG POSTGRES_VERSION=16-alpine
FROM postgres:${POSTGRES_VERSION}

ARG PG_PARTMAN_VERSION=v5.2.2

# Download pg_partman
ADD "https://github.com/pgpartman/pg_partman/archive/$PG_PARTMAN_VERSION.tar.gz" pg_partman.tar.gz

RUN echo "https://dl-cdn.alpinelinux.org/alpine/v3.21/main" > /etc/apk/repositories \
    && echo "https://dl-cdn.alpinelinux.org/alpine/v3.21/community" >> /etc/apk/repositories \
    && set -ex \
    && apk add --no-cache --virtual .build-deps \
        autoconf \
        automake \
        g++ \
        clang \
        llvm \
        libtool \
        libxml2-dev \
        make \
        perl

# Install pg_partman
RUN mkdir -p /usr/src/pg_partman \
    && tar \
        --extract \
        --file pg_partman.tar.gz \
        --directory /usr/src/pg_partman \
        --strip-components 1 \
    && rm pg_partman.tar.gz \
    && cd /usr/src/pg_partman \
    && make \
    && make install \
    && cd / \
    && rm -rf /usr/src/pg_partman

# Clean up installed dependencies
RUN set -ex \
    && apk del .build-deps
