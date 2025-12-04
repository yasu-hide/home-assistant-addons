ARG BUILD_FROM=ghcr.io/hassio-addons/base:19.0.0
FROM ghcr.io/druggeri/nut_exporter:latest as source
FROM ${BUILD_FROM}

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Setup base
RUN apk add --no-cache libc6-compat

# Copy program
WORKDIR /app
COPY --from=source /nut_exporter /app/nut_exporter
COPY run.sh /app/run.sh
RUN chmod a+x /app/nut_exporter /app/run.sh

# Build arguments
ARG BUILD_ARCH
ARG BUILD_DATE
ARG BUILD_DESCRIPTION
ARG BUILD_NAME
ARG BUILD_REF
ARG BUILD_REPOSITORY
ARG BUILD_VERSION
ENV S6_VERBOSITY="1"

CMD ["/app/run.sh"]

# Labels
LABEL \
    io.hass.name="${BUILD_NAME}" \
    io.hass.description="${BUILD_DESCRIPTION}" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION}
