{pkgs, ...}:
pkgs.writeShellScriptBin "my-stalonetray" ''
  ${pkgs.procps}/bin/pkill -x stalonetray
  sleep 1
  ${pkgs.stalonetray}/bin/stalonetray &
''
