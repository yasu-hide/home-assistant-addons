ARG BUILD_FROM=ghcr.io/hassio-addons/base:21.0.0
ARG TARGETARCH

# MinimServer publishes architecture-specific images rather than a
# multi-platform manifest.
FROM --platform=linux/amd64 minimworld/minimserver:latest AS minimserver_amd64
FROM --platform=linux/arm64 minimworld/minimserver:latest-arm64 AS minimserver_arm64

# Select the upstream MinimServer image for the requested build architecture.
FROM minimserver_${TARGETARCH} AS minimserver

# Temurin publishes a multi-platform Alpine image. Declare explicit platform
# stages as well, so the selected JRE architecture follows TARGETARCH.
FROM --platform=linux/amd64 eclipse-temurin:25-jre-alpine AS temurin_amd64
FROM --platform=linux/arm64 eclipse-temurin:25-jre-alpine AS temurin_arm64

# Select the Temurin JRE for the requested build architecture.
FROM temurin_${TARGETARCH} AS temurin

# Final Home Assistant app image, following the multi-stage pattern used by
# the other apps in this repository.
FROM ${BUILD_FROM}

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Copy MinimServer and the matching Temurin JRE into the Home Assistant image.
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
