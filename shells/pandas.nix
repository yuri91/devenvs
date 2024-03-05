{ lib
, python3
, mkShell
}:
let
  pythonEnv = python3.withPackages (pyPkgs: with pyPkgs; [
    numpy
    pandas
  ]);
in
mkShell {
  packages = [
    pythonEnv
  ];
}
