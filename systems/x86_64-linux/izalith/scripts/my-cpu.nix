{pkgs, ...}:
pkgs.writeShellScriptBin "my-cpu" ''
  vmstat 1 2 | tail -n 1 | awk '{print 100 - $15}'
''
