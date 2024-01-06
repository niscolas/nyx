{pkgs, ...}:
pkgs.writeShellScriptBin "my-ram" ''
  get_percentage() {
   mem_info=$(free | awk '/^Mem:/{print $3,$2}')

   used_mem=$(echo $mem_info | awk '{print $1}')
   total_mem=$(echo $mem_info | awk '{print $2}')

   echo $((used_mem * 100 / total_mem))
  }

  if [[ "$1" == "--percent" ]]; then
    get_percentage
  fi
''
