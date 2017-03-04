#!/usr/bin/env sh
set -ex
cd /tmp
apk update
apk upgrade

BUILD_DEPS="make gcc g++ linux-headers python pcre-dev openssl-dev zlib-dev"
RUN_DEPS="pcre libssl1.0 musl libcrypto1.0 busybox zlib"

if [ -z "$WITH_LUA" ]; then
	WITH_LUA=
else
	BUILD_DEPS="$BUILD_DEPS lua5.3-dev"
	RUN_DEPS="$RUN_DEPS lua5.3-libs"
fi

# Compile Haproxy
wget http://www.haproxy.org/download/${HAPROXY_MAJOR}/src/haproxy-${HAPROXY_VERSION}.tar.gz
tar -xzf haproxy-*.tar.gz
cd haproxy-*

# install build dependencies
apk add --virtual build-dependencies ${BUILD_DEPS}

# build
make PREFIX=/usr TARGET=linux2628 USE_PCRE=1 USE_PCRE_JIT=1 USE_OPENSSL=1 USE_ZLIB=1 \
	USE_LUA=$WITH_LUA LUA_LIB=/usr/lib/lua5.3/ LUA_INC=/usr/include/lua5.3

# install
make PREFIX=/usr install-bin
mkdir -p /etc/haproxy

# remove build dependencies
apk del build-dependencies

# install run dependencies
apk add ${RUN_DEPS}

# clean
cd -
rm -rf /tmp/*
rm -rf /var/cache/apk/*
