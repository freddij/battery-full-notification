#!/usr/bin/env bash
cd $(dirname $0)
PIDFILE=$(basename $0 .sh).pid
if [ -f $PIDFILE ]; then
  if [ -e /proc/$(cat $PIDFILE) ]; then
    exit 0
  fi
fi
echo $BASHPID > $PIDFILE

while true
do
    export DISPLAY=:0.0
    battery_percent=$(cat /sys/class/power_supply/BAT0/capacity)
    if on_ac_power; then
        if [ "$battery_percent" -ge 88 ]; then
            notify-send -i "$PWD/batteryfull.png" "Battery full." "Level: ${battery_percent}% "
            paplay /usr/share/sounds/freedesktop/stereo/alarm-clock-elapsed.oga
        fi
    else
        if [ "$battery_percent" -le 22 ]; then
            notify-send -i "$PWD/batteryfull.png" "Battery empty." "Level: ${battery_percent}% "
            paplay /usr/share/sounds/freedesktop/stereo/alarm-clock-elapsed.oga
        fi
    fi
    sleep 30 # (5 minutes)
done
