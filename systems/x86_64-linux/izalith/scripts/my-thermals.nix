{
  config,
  pkgs,
  ...
}:
pkgs.writeShellScriptBin "my-thermals" ''
  if [[ "$1" == "--cpu" ]]; then
    ${pkgs.acpi}/bin/acpi -t | awk '{print $4}'
  elif [[ "$1" == "--gpu" ]]; then
    echo ""
  fi
''
