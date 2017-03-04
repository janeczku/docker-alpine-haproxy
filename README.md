# HAProxy Alpine Linux image

[![](https://images.microbadger.com/badges/image/janeczku/alpine-haproxy.svg)](https://microbadger.com/images/janeczku/alpine-haproxy) [![Docker Pulls](https://img.shields.io/docker/pulls/janeczku/alpine-haproxy.svg)](https://hub.docker.com/r/janeczku/alpine-haproxy/)

A micro image providing HAProxy based on [Alpine Linux](https://hub.docker.com/_/alpine/).

[Github source](https://github.com/janeczku/docker-alpine-haproxy)

## Supported tags

-	`1.6.11`, `1.6`
-	`1.6.11-lua`, `1.6-lua`
-	`1.7.3`, `1.7`, `latest`
-	`1.7.3-lua`, `1.7-lua`

## What is HAProxy?

HAProxy is a free, open source high availability solution, providing load balancing and proxying for TCP and HTTP-based applications by spreading requests across multiple servers. It is written in C and has a reputation for being fast and efficient (in terms of processor and memory usage).

> [wikipedia.org/wiki/HAProxy](https://en.wikipedia.org/wiki/HAProxy)

## How to use this image

Since no two users of HAProxy are likely to configure it exactly alike, this image does not come with any default configuration.

Please refer to [upstream's excellent (and comprehensive) documentation](https://cbonte.github.io/haproxy-dconv/) on the subject of configuring HAProxy for your needs.

It is also worth checking out the [`examples/` directory from upstream](http://www.haproxy.org/git?p=haproxy-1.7.git;a=tree;f=examples).

Note: Many configuration examples propose to put `daemon` into the `global` section to run HAProxy as daemon. Do **not** configure this or the Docker container will exit immediately after launching because the HAProxy process would go into the background.

## Create a `Dockerfile`

```dockerfile
FROM janeczku/alpine-haproxy:1.7
COPY haproxy.cfg /etc/haproxy
```

Build and run:

```console
$ docker build -t repo/haproxy .
$ docker run -d repo/haproxy
```

## Directly via bind mount

```console
$ docker run -d -v /path/to/haproxy.cfg:/etc/haproxy/haproxy.cfg:ro janeczku/alpine-haproxy:1.7
```
