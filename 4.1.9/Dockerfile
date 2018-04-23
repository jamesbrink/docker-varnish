FROM alpine:3.7

# Build arguments.
ARG VCS_REF
ARG BUILD_DATE
ARG VARNISH_VERSION="4.1.9"

# Labels / Metadata.
LABEL maintainer="James Brink, brink.james@gmail.com" \
    decription="Varnish" \
    version="${VARNISH_VERSION}" \
    org.label-schema.name="varnish" \
    org.label-schema.build-date=$BUILD_DATE \
    org.label-schema.vcs-ref=$VCS_REF \
    org.label-schema.vcs-url="https://github.com/jamesbrink/docker-varnish" \
    org.label-schema.schema-version="1.0.0-rc1"

# Create our group & user.
RUN addgroup -g 1000 -S varnish \
    && adduser -u 1000 -S -h /varnish -s /bin/sh -G varnish varnish

# Copy in needed patches
COPY ./patches/ /varnish/patches

# Install deps.
RUN set -xe; \
    apk --update add --no-cache --virtual .runtime-deps \
        bash \
        gcc \
        graphviz \
        libcap \
        libc-dev \
        libexecinfo \
        libgcc \
        ncurses \
        pcre \
        readline; \
    echo "${VARNISH_VERSION}" > /varnish/version.txt; \
    chown varnish:varnish /varnish/version.txt; \
    apk add --no-cache --virtual .build-deps \
        alpine-sdk \
        graphviz-dev \
        libexecinfo-dev \
        linux-headers \
        ncurses-dev \
        pcre-dev \
        py-docutils \
        python2-dev \
        readline-dev \
        wget; \
    cd /varnish; \
    wget "https://varnish-cache.org/_downloads/varnish-${VARNISH_VERSION}.tgz"; \
    tar xfv varnish-${VARNISH_VERSION}.tgz; \
    rm varnish-${VARNISH_VERSION}.tgz; \
    cd /varnish/varnish-${VARNISH_VERSION}; \
    for p in /varnish/patches/*.patch; do \
        patch -p0 <$p; \
    done; \
    ./configure --prefix=/usr/local; \
    make; \
    make install; \
    mkdir -p /usr/local/etc/varnish; \
    cp -p ./etc/*.vcl /usr/local/etc/varnish/; \
    cd /varnish; \
    if [ "${VARNISH_VERSION}" != "6.0.0" ]; then \
        wget https://download.varnish-software.com/varnish-modules/varnish-modules-0.13.0.tar.gz \
        && tar xfvz varnish-modules-0.13.0.tar.gz \
        && rm varnish-modules-0.13.0.tar.gz \
        && cd varnish-modules-0.13.0 \
        && ./configure --prefix=/usr/local \
        && make \
        && make install \
        && cd /varnish/ \
        && rm -rf varnish-modules-0.13.0; \
    fi; \
    rm -rf varnish-${VARNISH_VERSION}; \
    rm -rf /varnish/patches; \
    setcap cap_net_bind_service=+ep /usr/local/sbin/varnishd; \
    chown varnish:varnish /usr/local/var/varnish; \
    apk del .build-deps;
    

# Copy our entrypoint into the container.
COPY ./docker-assets /

# Setup our environment variables.
ENV PATH="/usr/local/bin:/usr/local/sbin:$PATH"

# Drop down to our unprivileged user.
USER varnish

# Set our working directory.
WORKDIR /varnish

# Set the entrypoint.
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

# Set the default command
CMD ["/bin/bash"]
