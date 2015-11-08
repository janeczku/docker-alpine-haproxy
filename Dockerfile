FROM alpine:3.2

ENV HAPROXY_MAJOR 1.6
ENV HAPROXY_VERSION 1.6.2

RUN apk add haproxy --update-cache --repository http://dl-3.alpinelinux.org/alpine/edge/main/ --allow-untrusted \
  && rm -rf /etc/haproxy/haproxy.cfg \
  && rm -rf /var/cache/apk/*

CMD [ "/usr/sbin/haproxy", "-f", "/etc/haproxy/haproxy.cfg", "-db" ]