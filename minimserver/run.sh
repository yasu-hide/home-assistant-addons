#!/usr/bin/with-contenv bashio
set -e

# Require explicit acceptance of the MinimServer 2 license terms before starting.
if ! bashio::config.true 'accept_eula'; then
    bashio::log.error "Please read the MinimServer 2 license terms at https://minimserver.com/license-popup.html and enable 'accept_eula' in the add-on configuration to start MinimServer."
    exit 1
fi

# Do not start MinimServer while the library directory is empty or unavailable
# (e.g. the NAS behind the network storage is down). Starting with an empty
# content directory makes MinimServer drop its library index on rescan.
until [ -n "$(timeout 10 ls -A /media/Music 2>/dev/null)" ]; do
    bashio::log.warning "/media/Music is empty or unavailable (NAS down?). Waiting before starting MinimServer..."
    sleep 30
done

# MinimServer auto-detects a library mounted at /Music (same as the upstream container).
ln -sfn /media/Music /Music
bashio::log.info "Linked /media/Music to /Music"

bashio::log.info "Starting MinimServer with ${JAVA_VERSION}"
exec /bin/sh /opt/minimserver/bin/startd wait
