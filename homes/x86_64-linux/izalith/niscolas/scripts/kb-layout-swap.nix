{pkgs, ...}:
pkgs.writeShellScriptBin "kb-layout-swap" ''
  layout=${pkgs.xorg.setxkbmap}/bin/setxkbmap -query | grep layout: | awk '{print $2}'

  if [ "$layout" == "us" ]; then
      newlayout = "br"
  else
      newlayout = "us"
  fi

  ${pkgs.xorg.setxkbmap} "$newlayout"
''
