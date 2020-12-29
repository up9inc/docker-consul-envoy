ARG ENVOY_VERSION

FROM envoyproxy/envoy-alpine:v${ENVOY_VERSION}

ENV CONSUL_HTTP_ADDR=http://localhost:8500

ARG CONSUL_VERSION
#ENV CONSUL_VERSION=${CONSUL_VERSION}
RUN apk add -u bash curl && \
    wget https://releases.hashicorp.com/consul/"${CONSUL_VERSION}"/consul_"${CONSUL_VERSION}"_linux_amd64.zip \
	-O /tmp/consul.zip && \
    unzip /tmp/consul.zip -d /tmp && \
    mv /tmp/consul /usr/local/bin/consul && \
    rm -f /tmp/consul.zip

# haiut: dirty hack for Docker-Compose & Consul
COPY ./dc-hack/rinetd.bin.linux /usr/sbin/rinetd
COPY ./dc-hack/rinetd.conf /etc/rinetd.conf
RUN chmod 700 /usr/sbin/rinetd && chmod 600 /etc/rinetd.conf
# haiut: end

COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
