{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.nyx.niscolas.git;
in {
  options.nyx.niscolas.git = {
    enable = lib.mkEnableOption {};
  };

  config = lib.mkIf cfg.enable {
    programs.git = {
      enable = true;

      aliases = {
        aa = "add -A";
        ch = "checkout";
        cm = "commit";
        cma = "commit --amend --no-edit";
        cmm = "commit -m";
        s = "status -sb";
        sm = "submodule";
        sr = "submodule foreach git s";
        t = "log --graph --pretty=format:'%Cred%h%Creset - %Cgreen(%ad)%C(yellow)%d%Creset %s %C(bold blue)<%an>%Creset' --abbrev-commit --date=local";
        hide = "update-index --assume-unchanged";
        unhide = "update-index --no-assume-unchanged";
      };

      delta = {
        enable = true;
        options = {
          line-numbers = true;
          navigate = true; # use n and N to move between diff sections
          side-by-side = true;
          syntax-theme = "gruvbox-dark";
        };
      };

      extraConfig = {
        core.autocrlf = "input";

        credential.helper = "${
          pkgs.git.override {withLibsecret = true;}
        }/bin/git-credential-libsecret";

        diff = {
          colorMoved = "default";
        };
      };

      userName = "niscolas";
      userEmail = "niscolas@proton.me";
      lfs.enable = true;
    };
  };
}
