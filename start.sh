#!/bin/sh
# Abasthan start command: ./start.sh
# Env vars set in the Abasthan dashboard (never committed to this repo):
#   UUID    - VLESS client id
#   WS_PATH - WebSocket path, e.g. /ws-xxxxxxxx
#   PORT    - injected by Abasthan; Xray listens on it directly, TLS is
#             terminated at the Abasthan/Cloudflare edge, so Xray uses security=none.
set -eu

UUID="${UUID:?UUID env var is required}"
WS_PATH="${WS_PATH:?WS_PATH env var is required}"
PORT="${PORT:-8080}"

case "$WS_PATH" in /*) ;; *) WS_PATH="/$WS_PATH";; esac

sed -e "s|__UUID__|$UUID|g" -e "s|__WS_PATH__|$WS_PATH|g" -e "s|__PORT__|$PORT|g" \
  xray.template.json > xray.json

echo "Xray starting on port $PORT, ws path $WS_PATH"
exec ./xray run -c xray.json
