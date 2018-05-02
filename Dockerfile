FROM alpine:latest

COPY repositories /etc/apk/repositories
COPY pip.conf /root/.pip/pip.conf

RUN apk update \
    && apk -U --no-cache add --virtual build-dependencies \
        gcc \
        libffi-dev \
        libxml2-dev \
        libxslt-dev \
        musl-dev \
	mysql-client \
	mariadb-dev \
	build-base \
        python-dev \
        py-imaging \
        py-pip \
        curl ca-certificates \
    && update-ca-certificates \
    && rm -rf /var/cache/apk/* \
    && pip install --upgrade pip \
    && pip install --no-cache-dir mysql-python Scrapy scrapy-redis 

WORKDIR /runtime/app

COPY entrypoint.sh /runtime/entrypoint.sh
RUN chmod +x /runtime/entrypoint.sh

ENTRYPOINT ["/runtime/entrypoint.sh"]
CMD ["scrapy"]
