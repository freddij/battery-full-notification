#!/usr/bin/env bash
CEIL=71
FLOOR=39
PIDFILE=/tmp/$(basename $0 .sh).pid

cd $(dirname $0)
if [ -f $PIDFILE ]; then
  if [ -e /proc/$(cat $PIDFILE) ]; then
    exit 0
  fi
fi
echo $BASHPID > $PIDFILE

ifttt () {
#	curl -X POST https://maker.ifttt.com/trigger/lumi/with/key/bBNJN4Jn-P2XfSzdIAeIrb
	curl -sS -X POST https://maker.ifttt.com/trigger/Acome/with/key/bBNJN4Jn-P2XfSzdIAeIrb
}

while sleep 120 # (2 minutes following sensor update interval)
do
    #export DISPLAY=:0.0
    battery_percent=$(cat /sys/class/power_supply/BAT0/capacity)
    if on_ac_power; then
        if [ "$battery_percent" -ge $CEIL ]; then
            ifttt
            ( notify-send -i "/usr/share/icons/hicolor/scalable/status/battery-full-charging-symbolic.svg" "Battery Charged!" "Level: ${battery_percent}% "
            paplay /usr/share/sounds/freedesktop/stereo/alarm-clock-elapsed.oga
            which zenity && zenity --warning --text="Battery Charged!" --icon-name=battery-full-charging-symbolic ) &
            #which kdialog && kdialog --msgbox "Battery Charged!" &
        fi
    else
        if [ "$battery_percent" -le $FLOOR ]; then
            ifttt
            ( notify-send -i "/usr/share/icons/hicolor/scalable/status/battery-low-symbolic.svg" "Charge Battery!" "Level: ${battery_percent}% "
            paplay /usr/share/sounds/freedesktop/stereo/alarm-clock-elapsed.oga
            which zenity && zenity --warning --text="Charge Battery!" --icon-name=battery-low-symbolic ) &
            #which kdialog && kdialog --msgbox "Charge Battery!" &
        fi
    fi
done
