{pkgs, ...}:
pkgs.writeShellScriptBin "my-bspwm-eww-workspaces" ''
  target_file="$XDG_CACHE_HOME/eww_workspaces"
  touch "$target_file"

  focused_icon=""
  not_focused_icon=""
  result="(box :class 'workspaces-content' :spacing 12 :space-evenly 'false'"

  for desktop in $(bspc query -D -m .focused); do
      workspace_icon="$not_focused_icon"
      classes="workspace "

      if bspc query -N -d "$desktop" | grep -q .; then
          classes="$classes workspace-occupied "
      else
          classes="$classes workspace-unoccupied "
      fi

      focused_desktop="$(bspc query -D -d)"
      if [ "$focused_desktop" == "$desktop" ]; then
          classes="$classes workspace-focused "
          workspace_icon="$focused_icon"
      fi

      result="$result (button \
  :onclick 'desktop -f focused:$desktop' \
  :class '$classes' \
  '$workspace_icon' ) "
  done

  result="$result )"
  echo "$result" >> "$target_file"
''
