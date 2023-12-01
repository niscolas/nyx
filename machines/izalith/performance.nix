{...}: {
  services = {
    undervolt = {
      enable = false;
      temp = 85;
      coreOffset = -80;
      gpuOffset = -20;
    };

    tlp = {
      enable = false;
      settings = {
        CPU_BOOST_ON_AC = 1;
        CPU_BOOST_ON_BAT = 0;

        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

        CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
        CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

        #CPU_MIN_PERF_ON_AC = 0;
        CPU_MAX_PERF_ON_AC = 100;
        #CPU_MIN_PERF_ON_BAT = 0;
        CPU_MAX_PERF_ON_BAT = 20;

        # The following prevents the battery from charging fully to
        # preserve lifetime. Run `tlp fullcharge` to temporarily force
        # full charge.
        # https://linrunner.de/tlp/faq/battery.html#how-to-choose-good-battery-charge-thresholds
        START_CHARGE_THRESH_BAT0 = 40;
        STOP_CHARGE_THRESH_BAT0 = 50;
      };
    };

    thermald.enable = true;
    auto-cpufreq.enable = true;
    throttled = {
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
        PL2_Tdp_W: 44
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
        GPU: -30
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
  };
}
