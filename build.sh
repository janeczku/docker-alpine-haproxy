#!/usr/bin/env sh
set -ex
cd /tmp
apk update
apk upgrade

# Pre-build
addgroup haproxy 2>/dev/null
adduser -S -H -h /var/lib/haproxy -s /bin/false -D \
	-G haproxy haproxy 2>/dev/null
mkdir -p /etc/haproxy

# Compile Haproxy

wget http://www.haproxy.org/download/1.6/src/haproxy-1.6.2.tar.gz
tar -xzf haproxy-*.tar.gz
cd haproxy-*
# install build dependencies
apk add make gcc g++ readline linux-headers python pcre-dev openssl-dev zlib-dev lua5.3-dev
# build
make PREFIX=/usr TARGET=linux2628 USE_PCRE=1 USE_PCRE_JIT=1 USE_OPENSSL=1 USE_ZLIB=1 USE_LUA=1 LUA_LIB=/usr/lib/lua5.3/ LUA_INC=/usr/include/lua5.3
# install
make PREFIX=/usr LUA_LIB=/usr/lib/lua5.3/ LUA_INC=/usr/include/lua5.3 install-bin
# remove build dependencies
apk del make gcc g++ linux-headers python pcre-dev openssl-dev zlib-dev lua5.3-dev
# install run dependencies
apk add pcre libssl1.0 musl libcrypto1.0 busybox lua5.3-libs linenoise

# clean
cd -
rm -rf /tmp/*
rm -rf /var/cache/apk/*
