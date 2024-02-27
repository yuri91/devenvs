{ lib
, git
, python3
, mkShell
, texliveFull
, yarn
, nodejs
, bikeshed
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
    yarn
    nodejs
    bikeshed
  ];
}
