{
  config,
  pkgs,
  ...
}: let
  nvidia-pkg = config.hardware.nvidia.package;
in
  pkgs.writeShellScriptBin "my-thermals" ''
    get_cpu_temp() {
      ${pkgs.acpi}/bin/acpi -t | awk '{print $4}'
    }

    get_gpu_temp() {
      ${pkgs.cwltool}/bin/nvidia-smi -q -d TEMPERATURE | rg "GPU Current Temp" | awk '{print $5}' | sed 's/$/ºC/'
    }

    if [[ "$1" == "--cpu" ]]; then
        get_cpu_temp
    elif [[ "$1" == "--gpu" ]]; then
        get_gpu_temp
    fi
  ''
