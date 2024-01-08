{pkgs, ...}:
pkgs.writeShellScriptBin "kb-layout-swap" ''
  get() {
    ${pkgs.xorg.setxkbmap}/bin/setxkbmap -query | grep layout: | awk '{print $2}'
  }

  swap() {
    layout=$(get)

    if [ "$layout" == "us" ]; then
        newlayout="br"
    else
        newlayout="us"
    fi

    ${pkgs.xorg.setxkbmap}/bin/setxkbmap "$newlayout"
  }

  if [[ "$1" == "--swap" ]]; then
    swap
  elif [[ "$1" == "--get" ]]; then
    get
  fi
''
