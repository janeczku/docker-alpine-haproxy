#!/usr/bin/env sh
set -ex
cd /tmp
apk update
apk upgrade

# Compile Haproxy
wget http://www.haproxy.org/download/1.6/src/haproxy-${HAPROXY_VERSION}.tar.gz
tar -xzf haproxy-*.tar.gz
cd haproxy-*

# install build dependencies
apk add --virtual build-dependencies make gcc g++ linux-headers python \
	pcre-dev openssl-dev zlib-dev lua5.3-dev

# build
make PREFIX=/usr TARGET=linux2628 USE_PCRE=1 USE_PCRE_JIT=1 USE_OPENSSL=1 USE_ZLIB=1 \
	USE_LUA=1 LUA_LIB=/usr/lib/lua5.3/ LUA_INC=/usr/include/lua5.3

# install
make PREFIX=/usr install-bin
mkdir -p /etc/haproxy

# remove build dependencies
apk del build-dependencies

# install run dependencies
apk add pcre libssl1.0 musl libcrypto1.0 busybox zlib lua5.3-libs

# clean
cd -
rm -rf /tmp/*
rm -rf /var/cache/apk/*
