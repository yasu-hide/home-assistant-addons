ARG BUILD_FROM=ghcr.io/hassio-addons/base:21.0.0
ARG TARGETARCH

# Download the official MinimServer 2.2 Linux archive for each architecture.
# The archive checksums are verified before extraction.
FROM --platform=linux/amd64 alpine:3.22 AS minimserver_amd64
ARG MINIMSERVER_ESUM="b0ebeb11eac35dec5ca57c647a8a91a0b3b787c83c8f5c35bd782cfa3a6440c6"
ARG MINIMSERVER_URL="https://minimworld.com/files/90a5236a837b2de4f0ab41ce4d80f917/MinimServer-2.2-linux-intel.tar.gz"
RUN apk add --no-cache curl && \
    mkdir -p /opt/minimserver && \
    curl -LfsSo /tmp/minimserver.tar.gz "${MINIMSERVER_URL}" && \
    echo "${MINIMSERVER_ESUM}  /tmp/minimserver.tar.gz" | sha256sum -c - && \
    tar xf /tmp/minimserver.tar.gz -C /opt/minimserver --strip-components=1 && \
    rm -f /tmp/minimserver.tar.gz

FROM --platform=linux/arm64 alpine:3.22 AS minimserver_arm64
ARG MINIMSERVER_ESUM="5b9e028aafb842e3645ae4821b1b1a1639d3c76806907a2ce1b5f8309dde01db"
ARG MINIMSERVER_URL="https://minimworld.com/files/90a5236a837b2de4f0ab41ce4d80f917/MinimServer-2.2-linux-arm64.tar.gz"
RUN apk add --no-cache curl && \
    mkdir -p /opt/minimserver && \
    curl -LfsSo /tmp/minimserver.tar.gz "${MINIMSERVER_URL}" && \
    echo "${MINIMSERVER_ESUM}  /tmp/minimserver.tar.gz" | sha256sum -c - && \
    tar xf /tmp/minimserver.tar.gz -C /opt/minimserver --strip-components=1 && \
    rm -f /tmp/minimserver.tar.gz

# Select the MinimServer archive for the requested build architecture.
FROM minimserver_${TARGETARCH} AS minimserver

# Select the official Eclipse Temurin 25 JRE Alpine image by architecture.
FROM --platform=linux/amd64 eclipse-temurin:25-jre-alpine AS temurin_amd64
FROM --platform=linux/arm64 eclipse-temurin:25-jre-alpine AS temurin_arm64
FROM temurin_${TARGETARCH} AS temurin

# Final Home Assistant app image.
FROM ${BUILD_FROM}

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# MinimServer's Linux binaries may require glibc compatibility libraries.
RUN apk add --no-cache gcompat libstdc++

COPY --from=minimserver /opt/minimserver /opt/minimserver
COPY --from=temurin /opt/java/openjdk /opt/java/openjdk
COPY run.sh /app/run.sh
RUN chmod a+x /app/run.sh

ENV JAVA_VERSION="25"
ENV JAVA_HOME=/opt/java/openjdk
ENV PATH="${JAVA_HOME}/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
ENV S6_VERBOSITY="1"

WORKDIR /app
CMD ["/app/run.sh"]

# Build arguments
ARG BUILD_ARCH
ARG BUILD_DATE
ARG BUILD_DESCRIPTION
ARG BUILD_NAME
ARG BUILD_REF
ARG BUILD_REPOSITORY
ARG BUILD_VERSION

# Labels
LABEL \
    io.hass.name="${BUILD_NAME}" \
    io.hass.description="${BUILD_DESCRIPTION}" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version="${BUILD_VERSION}"
