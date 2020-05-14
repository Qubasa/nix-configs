#!/bin/sh


get_battery_charging_status() {
    if [ "$(acpi -b | grep Discharging)" != "" ]; then
        echo "Discharging";
    else
        echo "Charging";
    fi
}
declare -a capacity_arr
capacity_arr=(





)

# get charge of all batteries, combine them
total_charge=$(acpi -b | awk '{print $4}' | grep -Eo "[0-9]+" | paste -sd+ | calc -p);

# get amount of batteries in the device
battery_number=$(acpi -b | wc -l);
percent=$((total_charge / battery_number));
index=$((percent / ( 100 / ${#capacity_arr[@]}) ))

if [ "$(get_battery_charging_status)" == "Charging" ]; then
  echo "$percent% "
elif [ $percent -ge 98 ]; then
  echo "100% ${capacity_arr[$index]}"
else
  echo "$percent% ${capacity_arr[$index]}"
fi
