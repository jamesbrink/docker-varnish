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
COPY ./varnish.alpine.patch /varnish/

# Install deps.
RUN set -xe; \
    apk --update add --no-cache --virtual .runtime-deps \
        bash \
        libexecinfo \
        ncurses \
        pcre \
        readline; \
    echo "${VARNISH_VERSION}" > /varnish/version.txt; \
    chown varnish:varnish /varnish/version.txt; \
    apk add --no-cache --virtual .build-deps \
        alpine-sdk \
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
    cd varnish-${VARNISH_VERSION}; \
    patch -p0 < /varnish/varnish.alpine.patch; \
    ./configure --prefix=/usr/local; \
    make; \
    make install; \
    cd /varnish; \
    rm -rf varnish-${VARNISH_VERSION}; \
    rm varnish.alpine.patch; \
    apk del .build-deps;


# Copy our entrypoint into the container.
COPY ./docker-assets /

# Setup our environment variables.
ENV PATH="/usr/local/bin:$PATH"

# Drop down to our unprivileged user.
USER varnish

# Set our working directory.
WORKDIR /varnish

# Set the entrypoint.
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

# Set the default command
CMD ["/bin/bash"]
