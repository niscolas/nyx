{pkgs, ...}: {
  programs.fish = {
    enable = true;
    shellAliases = {
      g = "git";
    };
  };
}
