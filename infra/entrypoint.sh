#!/bin/sh
set -eu

: "${PORT:=10000}"

# Keep the passwords file protected (still used for the public websocket listener)
chmod 600 /mosquitto/config/passwords

cat > /mosquitto/config/mosquitto.conf <<EOF
persistence true
persistence_location /mosquitto/data/
log_dest stdout
# Only log errors and warnings to filter out health-check protocol noise
log_type error
log_type warning

# Allow per-listener auth rules (otherwise allow_anonymous applies globally)
per_listener_settings true

# Internal MQTT (private network)
listener 1883 0.0.0.0
protocol mqtt
allow_anonymous true

# Public entrypoint via Render (HTTPS/WSS terminates at Render and forwards to this port)
listener ${PORT} 0.0.0.0
protocol websockets
allow_anonymous false
password_file /mosquitto/config/passwords
EOF

exec mosquitto -c /mosquitto/config/mosquitto.conf
