#!/bin/bash

SLEEP_TIME=5
SAFE_PERCENT=30
DANGER_PERCENT=16  # Warn when battery at this level.
CRITICAL_PERCENT=5
while true
do
	BATTINFO=$(acpi -b)
	DISCHARGING=$(echo $BATTINFO | grep Discharging)
	if [[ $DISCHARGING ]]; then
		CAPACITY=$(echo $BATTINFO | cut -f 4 -d " " | tr -d "%,")
		if [[ $CAPACITY -gt $SAFE_PERCENT ]]; then
			SLEEP_TIME=15
		else 
			SLEEP_TIME=10
			BATTINFO=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep "time to" | awk '{print $4" "$5}')
			if [[ $CAPACITY -le $CRITICAL_PERCENT ]]; then
				SLEEP_TIME=1
				/usr/bin/notify-send "Critically Low Battery" "Around $BATTINFO remaining"
			elif [[ $CAPACITY -le $DANGER_PERCENT ]]; then
				SLEEP_TIME=5
				/usr/bin/notify-send "Low Battery" "Around $BATTINFO remaining"
			fi
		fi
	else
		SLEEP_TIME=10
	fi
	sleep ${SLEEP_TIME}m
done
