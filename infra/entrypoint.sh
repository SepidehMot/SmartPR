#!/bin/sh
set -eu

: "${PORT:=10000}"

chmod 600 /mosquitto/config/passwords

cat > /mosquitto/config/mosquitto.conf <<EOF
persistence true
persistence_location /mosquitto/data/
log_dest stdout
log_type error
log_type warning

# IMPORTANT: allow different auth rules per listener
per_listener_settings true

# ---- Internal MQTT (anonymous OK) ----
listener 1883 0.0.0.0
protocol mqtt
allow_anonymous true

# ---- Public WebSockets (auth required) ----
listener ${PORT} 0.0.0.0
protocol websockets
allow_anonymous false
password_file /mosquitto/config/passwords
EOF

exec mosquitto -c /mosquitto/config/mosquitto.conf
