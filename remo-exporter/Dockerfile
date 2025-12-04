ARG BUILD_FROM=ghcr.io/hassio-addons/base:19.0.0
FROM kenfdev/remo-exporter:latest as source
FROM ${BUILD_FROM}

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Setup base
RUN apk add --no-cache ca-certificates && \
    addgroup exporter && \
    adduser -S -G exporter exporter

# Copy program
WORKDIR /app
COPY --from=source /remo-exporter /app/remo-exporter
COPY run.sh /app/run.sh
RUN chmod a+x /app/remo-exporter /app/run.sh

ENV LISTEN_PORT=9352
EXPOSE $LISTEN_PORT

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
