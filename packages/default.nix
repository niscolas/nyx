{pkgs, ...}: {
  rebuild = with pkgs;
    pkgs.writeScriptBin "rebuild" ''
      set -e
      pushd ~/bonfire/nyx/
      ${git}/bin/git diff -U0 *.nix
      echo "NixOS Rebuilding..."
      sudo nixos-rebuild switch --flake . &>nixos-switch.log || (
       cat nixos-switch.log | ${ripgrep}/bin/rg --color error && false)

      set +e
      gen=$(nixos-rebuild list-generations | ${ripgrep}/bin/rg current)
      set -e

      ${git}/bin/git commit -am "$gen"
      popd
    '';
}
