{ lib
, pkgs
, pkgsMusl
}:
let
  mkShell = pkgsMusl.mkShell;
in
mkShell {
  packages = with pkgs; [
    git
  ];
  hardeningDisable = [ "all" ];
}
