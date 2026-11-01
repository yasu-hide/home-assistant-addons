#!/usr/bin/with-contenv bashio
set -e

# MinimServer auto-detects a library mounted at /Music (same as the upstream container).
if [ -d /media/Music ]; then
    ln -sfn /media/Music /Music
    bashio::log.info "Linked /media/Music to /Music"
fi

bashio::log.info "Starting MinimServer with ${JAVA_VERSION}"
exec /bin/sh /opt/minimserver/bin/startd wait
