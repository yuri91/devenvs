{ lib
, git
, python3
, mkShell
, texliveFull
}:
let
  pythonEnv = python3.withPackages (pyPkgs: with pyPkgs; [
    sphinx
    six
  ]);
in
mkShell {
  packages = [
    git
    pythonEnv
    texliveFull
  ];
}
