{pkgs, ...}:
pkgs.writeShellScriptBin "launch-eww-bar" ''
  eww -c ~/.config/eww/bar open bar
''
