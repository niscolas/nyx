{lib, ...}: {
  services.system76-scheduler.enable = true;
  services.power-profiles-daemon.enable = false;
  services.thermald.enable = false;
  services.auto-cpufreq = {
    enable = false;
    settings = {
      battery = {
        governor = "powersave";
        turbo = "never";
      };
      charger = {
        governor = "performance";
        turbo = "auto";
      };
    };
  };
  services.tlp = {
    enable = true;
    settings = {
      CPU_BOOST_ON_AC = 0;
      CPU_BOOST_ON_BAT = 0;

      CPU_SCALING_GOVERNOR_ON_AC = "powersave";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      CPU_ENERGY_PERF_POLICY_ON_AC = "power";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

      #CPU_MIN_PERF_ON_AC = 0;
      CPU_MAX_PERF_ON_AC = 75;
      #CPU_MIN_PERF_ON_BAT = 0;
      CPU_MAX_PERF_ON_BAT = 40;

      # The following prevents the battery from charging fully to
      # preserve lifetime. Run `tlp fullcharge` to temporarily force
      # full charge.
      # https://linrunner.de/tlp/faq/battery.html#how-to-choose-good-battery-charge-thresholds
      START_CHARGE_THRESH_BAT0 = 40;
      STOP_CHARGE_THRESH_BAT0 = 75;
    };
  };
  services.throttled = {
    enable = true;
    extraConfig = ''
      [GENERAL]
      # Enable or disable the script execution
      Enabled: True
      # SYSFS path for checking if the system is running on AC power
      Sysfs_Power_Path: /sys/class/power_supply/AC*/online
      # Auto reload config on changes
      Autoreload: True

      ## Settings to apply while connected to Battery power
      [BATTERY]
      # Update the registers every this many seconds
      Update_Rate_s: 30
      # Max package power for time window #1
      PL1_Tdp_W: 29
      # Time window #1 duration
      PL1_Duration_s: 28
      # Max package power for time window #2
      PL2_Tdp_W: 29
      # Time window #2 duration
      PL2_Duration_S: 0.002
      # Max allowed temperature before throttling
      Trip_Temp_C: 75
      # Set cTDP to normal=0, down=1 or up=2 (EXPERIMENTAL)
      cTDP: 0
      # Disable BDPROCHOT (EXPERIMENTAL)
      Disable_BDPROCHOT: False

      ## Settings to apply while connected to AC power
      [AC]
      # Update the registers every this many seconds
      Update_Rate_s: 5
      # Max package power for time window #1
      PL1_Tdp_W: 44
      # Time window #1 duration
      PL1_Duration_s: 28
      # Max package power for time window #2
      PL2_Tdp_W: 44
      # Time window #2 duration
      PL2_Duration_S: 0.002
      # Max allowed temperature before throttling
      Trip_Temp_C: 85
      # Set HWP energy performance hints to 'performance' on high load (EXPERIMENTAL)
      # Uncomment only if you really want to use it
      # HWP_Mode: False
      # Set cTDP to normal=0, down=1 or up=2 (EXPERIMENTAL)
      cTDP: 0
      # Disable BDPROCHOT (EXPERIMENTAL)
      Disable_BDPROCHOT: False

      # All voltage values are expressed in mV and *MUST* be negative (i.e. undervolt)!
      [UNDERVOLT]
      # CPU core voltage offset (mV)
      CORE: -80
      # Integrated GPU voltage offset (mV)
      GPU: 0
      # CPU cache voltage offset (mV)
      CACHE: -80
      # System Agent voltage offset (mV)
      UNCORE: 0
      # Analog I/O voltage offset (mV)
      ANALOGIO: 0

      # [ICCMAX.AC]
      # # CPU core max current (A)
      # CORE:
      # # Integrated GPU max current (A)
      # GPU:
      # # CPU cache max current (A)
      # CACHE:

      # [ICCMAX.BATTERY]
      # # CPU core max current (A)
      # CORE:
      # # Integrated GPU max current (A)
      # GPU:
      # # CPU cache max current (A)
      # CACHE:
    '';
  };
  powerManagement.powertop.enable = false;
  specialisation = {
    turbo.configuration = {
      environment.etc.current-specialisation.text = lib.mkForce ''
        (󰑣)
      '';

      services = {
        tlp = {
          enable = lib.mkForce true;
          settings = {
            CPU_BOOST_ON_AC = lib.mkForce 1;
            CPU_SCALING_GOVERNOR_ON_AC = lib.mkForce "performance";
            CPU_ENERGY_PERF_POLICY_ON_AC = lib.mkForce "performance";
            CPU_MAX_PERF_ON_AC = lib.mkForce 100;
          };
        };
      };
    };
    eco.configuration = {
      environment.etc.current-specialisation.text = lib.mkForce ''
        ()
      '';

      services = {
        tlp = {
          enable = lib.mkForce true;
          settings = {
            CPU_BOOST_ON_AC = lib.mkForce 0;
            CPU_SCALING_GOVERNOR_ON_AC = lib.mkForce "powersave";
            CPU_ENERGY_PERF_POLICY_ON_AC = lib.mkForce "power";
            CPU_MAX_PERF_ON_AC = lib.mkForce 50;
          };
        };
      };
    };
  };
}
