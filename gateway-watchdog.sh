#!/bin/ash
#
# === CONFIGURATION ====
CABLE_GW="172.30.0.1"
WIFI_GW="172.30.0.3"
PING_TARGET="118.136.64.5"
#PING_TARGET="202.73.99.2"
#PING_TARGET="8.8.4.4"
UCI_GW="network.lan.gateway"
# ======================

GATEWAY=$(uci get $UCI_GW)
ip route add "$PING_TARGET" via "$CABLE_GW"
ping -q -c 3 -W 2 "$PING_TARGET" > /dev/null 2>&1
CABLE_STATUS=$?
ip route del "$PING_TARGET" via "$CABLE_GW"
if [ $CABLE_STATUS -ne 0 ]; then
  if [ "$GATEWAY" = "$CABLE_GW" ]; then
    echo "$(date +'%F %T'): Cable disconnected. Switching to WiFi" >> /var/log/gateway.log
    uci set ${UCI_GW}=${WIFI_GW}
    uci commit network
    /etc/init.d/network reload
  fi
else
  if [ ${GATEWAY} = ${WIFI_GW} ]; then
    echo "$(date +'%F %T'): Cable recovered. Switching to Cable" >> /var/log/gateway.log
    uci set ${UCI_GW}=${CABLE_GW}
    uci commit network
    /etc/init.d/network reload
  fi
fi
exit 0
