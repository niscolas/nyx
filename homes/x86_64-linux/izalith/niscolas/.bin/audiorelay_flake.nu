#!/usr/bin/env nu

with-env [ NIXPKGS_ALLOW_UNFREE 1 ] { nix run "github:JamesReynolds/audiorelay-flake" --impure }
