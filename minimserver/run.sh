#!/usr/bin/with-contenv bashio
set -e

bashio::log.info "Starting MinimServer with ${JAVA_VERSION}"
exec /bin/sh /opt/minimserver/bin/startd wait
