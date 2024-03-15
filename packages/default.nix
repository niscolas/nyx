{pkgs, ...}: {
  rebuild = with pkgs;
    pkgs.writeScriptBin "rebuild" ''
      set -e
      pushd ~/bonfire/nyx/
      ${git}/bin/git diff -U0 *.nix
      echo "NixOS Rebuilding..."
      sudo nixos-rebuild switch --flake . &>nixos-switch.log || (
       cat nixos-switch.log | grep --color error && false)

      set +e
      gen=$(nixos-rebuild list-generations | grep current | awk '{print $1}')
      set -e

      ${git}/bin/git add systems/x86_64-linux/izalith
      ${git}/bin/git add homes/x86_64-linux/izalith
      ${git}/bin/git add modules packages flake.nix flake.lock
      ${git}/bin/git commit -m "NixOS Switch: $gen"
      popd
    '';

  rebuild-liurnia-remote = ''
    nixos-rebuild switch --flake .#liurnia --target-host "root@liurnia"
  '';

  hm-switch-no-git = pkgs.writeScriptBin "hm-switch-no-git" ''
    set -e
    echo "Home Manager switching..."
    home-manager switch --show-trace --flake . &>hm-switch.log || (
     cat hm-switch.log | grep --color error && false)
  '';

  hm-switch = with pkgs;
    pkgs.writeScriptBin "hm-switch" ''
      set -e
      pushd ~/bonfire/nyx/
      ${git}/bin/git diff -U0 *.nix
      echo "Home Manager switching..."
      home-manager switch --show-trace --flake . &>hm-switch.log || (
       cat hm-switch.log | grep --color error && false)
      gen=$(home-manager generations | head -n 1 | awk '{print $5}')
      ${git}/bin/git commit -am "Home Manager Switch: $gen"
      popd
    '';

  deploy-liurnia = pkgs.writeScriptBin "deploy-liurnia" ''
    nix run github:nix-community/nixos-anywhere -- --flake .#liurnia root@liurnia
  '';
}
