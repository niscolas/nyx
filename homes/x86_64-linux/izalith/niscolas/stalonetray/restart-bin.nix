{pkgs, ...}:
pkgs.writeShellScriptBin "my-stalonetray" ''
  ${pkgs.procps}/bin/pkill -x stalonetray
  sleep 2
  ${pkgs.stalonetray}/bin/stalonetray &
''
