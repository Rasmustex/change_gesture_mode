#!/usr/bin/env -S bash -e
# Switches the gesture mode of the WACOM touch screen.
# Dependencies: libnotify

# Prevent multiple instances from running at the same time
pidfile=$HOME/change_gesture_mode.sh.pid

if test -f "$pidfile"; then
    echo "program already running"
else

trap "rm -f -- '$pidfile'" EXIT

echo $$ > "$pidfile"

# get device ID of finger touch screen
ID=`xsetwacom --list devices | sed -n "s/^.*Finger touch\s*id:\s*\(\S*\).*$/\1/p"`

STATUS=`xsetwacom --get $ID Gesture`

if [ $STATUS = "on" ]; then
    xsetwacom --set $ID Gesture off
else
    xsetwacom --set $ID Gesture on
fi

notify-send -u normal -t 100 "WACOM gesture mode has been switched `xsetwacom --get $ID Gesture`"
sleep 1
fi
