ARG TARGETARCH

FROM --platform=linux/amd64 minimworld/minimserver:latest AS base_amd64
ARG ESUM="69264a7a211bf5029830d07bc3370f879769d62ebc5b5488e90c9343a2da0e1f"
ARG BINARY_URL="https://github.com/adoptium/temurin25-binaries/releases/download/jdk-25.0.3%2B9/OpenJDK25U-jdk_x64_linux_hotspot_25.0.3_9.tar.gz"

FROM --platform=linux/arm64 minimworld/minimserver:latest-arm64 AS base_arm64
ARG ESUM="3e4287cb98870ba824ed698854bdc27cff984254caf66dd12cc291e7bfdde26b"
ARG BINARY_URL="https://github.com/adoptium/temurin25-binaries/releases/download/jdk-25.0.3%2B9/OpenJDK25U-jdk_aarch64_linux_hotspot_25.0.3_9.tar.gz"

FROM base_${TARGETARCH} AS final

ENV JAVA_VERSION="jdk-25.0.3+9"
ENV JAVA_HOME=/opt/java/openjdk
ENV PATH="${JAVA_HOME}/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

RUN curl -LfsSo /tmp/openjdk.tar.gz "${BINARY_URL}" && \
    echo "${ESUM} */tmp/openjdk.tar.gz" | sha256sum -c - && \
    mkdir -p "${JAVA_HOME}" && \
    tar xf /tmp/openjdk.tar.gz -C "${JAVA_HOME}" --strip-components=1 && \
    rm -f /tmp/openjdk.tar.gz

ARG BUILD_ARCH
ARG BUILD_DATE
ARG BUILD_DESCRIPTION
ARG BUILD_NAME
ARG BUILD_REF
ARG BUILD_REPOSITORY
ARG BUILD_VERSION

LABEL \
    io.hass.name="${BUILD_NAME}" \
    io.hass.description="${BUILD_DESCRIPTION}" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version="${BUILD_VERSION}"
