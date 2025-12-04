#!/usr/bin/with-contenv bashio
set -e

bashio::log.info "🔹 Welcome to Prometheus Nature Remo Exporter"

OAUTH_TOKEN="$(bashio::config 'OAUTH_TOKEN')"
METRICS_PATH="$(bashio::config 'METRICS_PATH')"
API_BASE_URL="$(bashio::config 'API_BASE_URL')"
PORT="$(bashio::config 'PORT')"
CACHE_INVALIDATION_SECONDS="$(bashio::config 'CACHE_INVALIDATION_SECONDS')"

bashio::log.info "✅ Configuration Loaded:"
bashio::log.info "  OAUTH_TOKEN=HIDDEN"
[ "${METRICS_PATH}" != "null" ] && \
  bashio::log.info "  METRICS_PATH=$METRICS_PATH"
[ "${API_BASE_URL}" != "null" ] && \
  bashio::log.info "  API_BASE_URL=$API_BASE_URL"
[ "${PORT}" != "null" ] && \
  bashio::log.info "  PORT=$PORT"
[ "${CACHE_INVALIDATION_SECONDS}" != "null" ] && \
  bashio::log.info "  CACHE_INVALIDATION_SECONDS=$CACHE_INVALIDATION_SECONDS"

while true; do
    bashio::log.info "🔹 Starting Remo Exporter..."
    # Custom variables are already exported above
    export OAUTH_TOKEN="$OAUTH_TOKEN"
    [ "${METRICS_PATH}" != "null" ] && export METRICS_PATH="$METRICS_PATH"
    [ "${API_BASE_URL}" != "null" ] && export API_BASE_URL="$API_BASE_URL"
    [ "${PORT}" != "null" ] && export PORT="$PORT"
    [ "${CACHE_INVALIDATION_SECONDS}" != "null" ] && export CACHE_INVALIDATION_SECONDS="$CACHE_INVALIDATION_SECONDS"
    /app/remo-exporter

    bashio::log.warning "Exporter stopped! Waiting 5 second before reconnecting..."
    sleep 5;
done
