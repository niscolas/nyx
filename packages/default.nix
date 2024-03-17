{pkgs, ...}: let
  configDir = "/home/niscolas/bonfire/nyx";
in {
  rebuild = pkgs.writeScriptBin "rebuild" ''
    sudo nixos-rebuild switch --show-trace --flake ${configDir}
  '';

  rebuild-git = with pkgs;
    pkgs.writeScriptBin "rebuild-git" ''
      set -e
      ${git}/bin/git diff -U0 *.nix
      echo "NixOS Rebuilding..."
      sudo nixos-rebuild switch --flake ${configDir} &>nixos-switch.log || (
       cat nixos-switch.log | grep --color error && false)

      set +e
      gen=$(nixos-rebuild list-generations | grep current | awk '{print $1}')
      set -e

      ${git}/bin/git add ${configDir}/systems/x86_64-linux/izalith
      ${git}/bin/git add ${configDir}/homes/x86_64-linux/izalith
      ${git}/bin/git add ${configDir}/modules
      ${git}/bin/git add ${configDir}/packages
      ${git}/bin/git add ${configDir}/flake.nix
      ${git}/bin/git add ${configDir}/flake.lock

      ${git}/bin/git commit -m "NixOS Switch: $gen"
    '';

  hm-switch = pkgs.writeScriptBin "hm-switch" ''
    home-manager switch --show-trace --flake ${configDir}
  '';

  hm-switch-git = with pkgs;
    pkgs.writeScriptBin "hm-switch" ''
      set -e
      ${git}/bin/git diff -U0 ${configDir}/*.nix
      echo "Home Manager switching..."
      home-manager switch --show-trace --flake ${configDir} &>hm-switch.log || (
       cat hm-switch.log | grep --color error && false)
      gen=$(home-manager generations | head -n 1 | awk '{print $5}')
      ${git}/bin/git commit -am "Home Manager Switch: $gen"
    '';

  deploy-liurnia = pkgs.writeScriptBin "deploy-liurnia" ''
    nix run github:nix-community/nixos-anywhere -- --flake ${configDir}#liurnia root@liurnia
  '';

  rebuild-liurnia-remote = pkgs.writeScriptBin "rebuild-liurnia-remote" ''
    nixos-rebuild switch --flake ${configDir}#liurnia --target-host "root@liurnia"
  '';

  # edit-liurnia-secrets = pkgs.writeScriptBin "edit-liurnia-secrets" ''
  #   SOPS_AGE_KEY_FILE=~/.config/sops/age/liurnia_keys.txt \
  #       ${pkgs.sops}/bin/sops \
  #       ${../systems/x86_64-linux/liurnia/secrets/secrets.yaml}
  # '';
}
