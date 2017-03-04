#!/usr/bin/env sh
set -ex

BUILD_DEPS="make gcc libc-dev linux-headers python pcre-dev openssl-dev zlib-dev"
RUN_DEPS="pcre libssl1.0 libcrypto1.0 zlib"

apk upgrade --no-cache

if [ -z "$WITH_LUA" ]; then
	WITH_LUA=
else
	BUILD_DEPS="$BUILD_DEPS lua5.3-dev"
	RUN_DEPS="$RUN_DEPS lua5.3-libs"
fi

# install build dependencies
apk add --no-cache --virtual build-deps ${BUILD_DEPS}

# compile haproxy
mkdir -p /usr/src/haproxy
wget -O haproxy.tar.gz http://www.haproxy.org/download/${HAPROXY_MAJOR}/src/haproxy-${HAPROXY_VERSION}.tar.gz
echo "$HAPROXY_MD5 *haproxy.tar.gz" | md5sum -c
tar -xzf haproxy.tar.gz -C /usr/src/haproxy --strip-components=1
rm haproxy.tar.gz
make -C /usr/src/haproxy all \
	PREFIX=/usr/ TARGET=linux2628 \
	USE_PCRE=1 USE_PCRE_JIT=1 \
	USE_OPENSSL=1 \
	USE_ZLIB=1 \
	USE_LUA=$WITH_LUA LUA_LIB=/usr/lib/lua5.3/ LUA_INC=/usr/include/lua5.3

# install haproxy
make -C /usr/src/haproxy install-bin PREFIX=/usr TARGET=linux2628
mkdir -p /etc/haproxy
cp -R /usr/src/haproxy/examples/errorfiles /etc/haproxy/errors

# remove build dependencies
apk del build-deps

# install run dependencies
apk add --no-cache ${RUN_DEPS}

# clean
rm -rf /usr/src/haproxy
