{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  cfg = config.erdtree.espanso;
in {
  options.erdtree.espanso = {
    enable = lib.mkEnableOption {};
  };

  config = lib.mkIf cfg.enable {
    services.espanso = {
      enable = true;
      matches = {
        base = {
          matches = [
            {
              trigger = ":now";
              replace = "It's {{currentdate}} {{currenttime}}";
            }
            {
              trigger = ":hello";
              replace = "line1\nline2";
            }
            {
              regex = ":hi(?P<person>.*)\\.";
              replace = "Hi {{person}}!";
            }
          ];
        };
        global_vars = {
          global_vars = [
            {
              name = "currentdate";
              type = "date";
              params = {format = "%d/%m/%Y";};
            }
            {
              name = "currenttime";
              type = "date";
              params = {format = "%R";};
            }
          ];
        };
      };
    };
  };
}
