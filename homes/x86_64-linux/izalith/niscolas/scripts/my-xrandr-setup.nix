{pkgs, ...}:
pkgs.writeShellScriptBin "my-xrandr-setup" ''
  battery_info=$(${pkgs.acpi}/bin/acpi -b | sed 's/\,//g')
  battery_status=$(echo "$battery_info" | awk '{print $3}')
  battery_percentage=$(echo "$battery_info" | awk '{print $4}')
  battery_remaining=$(echo "$battery_info" | awk '{print $5}' | sed 's/...$//')

  if [[ "$battery_status" == "Charging" ]]; then
    echo "󱊥 $battery_percentage ($battery_remaining)"
  elif [[ "$battery_status" == "Discharging" ]]; then
    echo "󱊡 $battery_percentage ($battery_remaining)"
  else
    echo "󱊣 $battery_percentage"
  fi
''
