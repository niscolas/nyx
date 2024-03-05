{pkgs, ...}: {
  rebuild = with pkgs;
    pkgs.writeScriptBin "rebuild" ''
      ${git}/bin/git diff -U0 *.nix
      echo "NixOS Rebuilding..."
      sudo nixos-rebuild switch --flake . &>nixos-switch.log || (
       cat nixos-switch.log | grep --color error && false)
      gen=$(nixos-rebuild list-generations | grep current)
      ${git}/bin/git commit -am "$gen"
    '';
}
