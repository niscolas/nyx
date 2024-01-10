{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.erdtree.autorandr;

  internalMonitorName = "eDP-1-1";
  internalMonitorEdid = "00ffffffffffff000dae211500000000091e0104a52213780328659759548e271e5054000000010101010101010101010101010101019e8580a070383e403020a50058c1100000189e8580a070387c463020a50058c110000018000000fe00434d4e0a202020202020202020000000fe004e3135364852412d4541310a2000e3";
  hdmiMonitorName = "HDMI-0";
  hdmiMonitorEdid = "00ffffffffffff0004728207360590121d1f010380341e782adcf1a655519d260e5054bfef80714f8140818081c081009500b3000101023a801871382d40582c45000f282100001e000000ff00544c5741413030323339303020000000fd0030a70fbe29000a202020202020000000fc005247323431590a202020202020012902033ff149020405101113141f3f230907078301000067030c001000383c67d85dc4015a88006d1a0000020130a5e60000000000e305e301e6060700606046046d80a070382840302035000f282100001ead8280a070382840302035000f282100001ec99580a070382840302035000f282100001e000000000000000000004d";
  defaultDpi = 120;
  defaultMode = "1920x1080";
  defaultHdmiRate = "143.60";
  defaultInternalRate = "144.0";
in {
  options.erdtree.autorandr = {
    enable = lib.mkEnableOption {};
    defaultProfile = lib.mkOption {
      type = lib.types.str;
      default = "work";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.autorandr = {
      enable = true;

      profiles = {
        work = {
          fingerprint = {
            "${internalMonitorName}" = "${internalMonitorEdid}";
          };
          config = {
            "${internalMonitorName}" = {
              enable = true;

              dpi = 140;
              mode = defaultMode;
              rate = defaultInternalRate;
            };
          };
        };

        internal = {
          fingerprint = {
            "${internalMonitorName}" = "${internalMonitorEdid}";
          };
          config = {
            "${internalMonitorName}" = {
              enable = true;

              dpi = defaultDpi;
              mode = defaultMode;
              rate = defaultInternalRate;
            };
          };
        };

        hdmi = {
          fingerprint = {
            "${hdmiMonitorName}" = "${hdmiMonitorEdid}";
          };

          config = {
            "${hdmiMonitorName}" = {
              enable = true;

              dpi = defaultDpi;
              mode = defaultMode;
              position = "0x0";
              primary = true;
              rate = defaultHdmiRate;
            };
          };
        };

        dual = {
          fingerprint = {
            "${internalMonitorName}" = "${internalMonitorEdid}";
            "${hdmiMonitorName}" = "${hdmiMonitorEdid}";
          };

          config = {
            "${hdmiMonitorName}" = {
              enable = true;

              dpi = defaultDpi;
              mode = defaultMode;
              position = "0x0";
              primary = true;
              rate = defaultHdmiRate;
            };

            "${internalMonitorName}" = {
              enable = true;

              dpi = defaultDpi;
              mode = defaultMode;
              position = "0x1080";
              rate = defaultInternalRate;
            };
          };
        };
      };
    };

    systemd.user.services.autorandr = {
      Unit = {
        Description = "autorandr";
        After = ["graphical-session-pre.target"];
        PartOf = ["graphical-session.target"];
      };

      Service = {
        Type = "oneshot";
        ExecStart = "${pkgs.autorandr}/bin/autorandr --force ${cfg.defaultProfile}";
      };

      Install.WantedBy = ["graphical-session.target"];
    };
  };
}
