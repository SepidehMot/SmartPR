#!/bin/sh
set -eu

: "${PORT:=10000}"
chmod 600 /mosquitto/config/passwords
cat > /mosquitto/config/mosquitto.conf <<EOF
persistence true
persistence_location /mosquitto/data/
log_dest stdout

allow_anonymous false
password_file /mosquitto/config/passwords

# Internal MQTT (not public on Render web service, but useful privately)
listener 1883 0.0.0.0
protocol mqtt

# Public entrypoint via Render (HTTPS/WSS terminates at Render and forwards to this port)
listener ${PORT} 0.0.0.0
protocol websockets
EOF

exec mosquitto -c /mosquitto/config/mosquitto.conf
