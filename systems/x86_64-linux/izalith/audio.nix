{config, ...}: {
  # Enable sound with pipewire.
  sound.enable = true;

  environment.etc."wireplumber/main.lua.d/90-suspend-timeout.lua" = {
    text = ''
      apply_properties = {
          ["session.suspend-timeout-seconds"] = 0,
      }
    '';
  };

  hardware = {
    pulseaudio = {
      enable = false;
      extraConfig = ''
        .nofail
        unload-module module-suspend-on-idle
        .fail
      '';
    };
  };

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;

    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };
}
