ARG BUILD_FROM=ghcr.io/hassio-addons/base:19.0.0
FROM vet5lqplpecmpnqb/2jciebu-prometheus:latest AS source
FROM ${BUILD_FROM}

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Setup base
RUN apk add --no-cache python3 py3-pip && \
    python3 -m venv /app && \
    source /app/bin/activate && \
    pip install --no-cache-dir pyserial prometheus-client

# Copy program
WORKDIR /app
COPY --from=source /tmp/main.py /app/main.py
COPY --from=source /tmp/sensor.py /app/sensor.py
COPY run.sh /app/run.sh
RUN chmod a+x /app/main.py /app/sensor.py /app/run.sh

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
