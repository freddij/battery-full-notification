#!/usr/bin/env bash
CEIL=82
FLOOR=28
PIDFILE=/tmp/$(basename $0 .sh).pid

cd $(dirname $0)
if [ -f $PIDFILE ]; then
  if [ -e /proc/$(cat $PIDFILE) ]; then
    exit 0
  fi
fi
echo $BASHPID > $PIDFILE

while sleep 120 # (2 minutes)
do
    export DISPLAY=:0.0
    battery_percent=$(cat /sys/class/power_supply/BAT0/capacity)
    if on_ac_power; then
        if [ "$battery_percent" -ge $CEIL ]; then
            notify-send -i "/usr/share/icons/hicolor/scalable/status/battery-full-charging-symbolic.svg" "Battery Charged!" "Level: ${battery_percent}% "
            paplay /usr/share/sounds/freedesktop/stereo/alarm-clock-elapsed.oga
            zenity --warning --text="Battery Charged!" --icon-name=battery-full-charging-symbolic
        fi
    else
        if [ "$battery_percent" -le $FLOOR ]; then
            notify-send -i "/usr/share/icons/hicolor/scalable/status/battery-low-symbolic.svg" "Charge Battery!" "Level: ${battery_percent}% "
            paplay /usr/share/sounds/freedesktop/stereo/alarm-clock-elapsed.oga
            zenity --warning --text="Charge Battery!" --icon-name=battery-low-symbolic
        fi
    fi
done
