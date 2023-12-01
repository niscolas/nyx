final: prev: {
  logseq = prev.logseq.overrideAttrs (oldAttrs: let
    newVersion = "0.10.0";
  in {
    version = "${newVersion}";

    src = final.pkgs.fetchurl {
      url = "https://github.com/logseq/logseq/releases/download/${newVersion}/logseq-linux-x64-${newVersion}.AppImage";
      hash = "sha256-igZM+kNe1GDPYckXU6fOjyovHe9gwyBWr7Mc3BxAzOA=";
      name = "${oldAttrs.pname}-${newVersion}.AppImage";
    };
  });
}
