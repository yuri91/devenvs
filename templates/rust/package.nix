{ lib
, rustPlatform
, pkg-config
}:
let
  runtime-deps = [
  ];
in
rustPlatform.buildRustPackage {
  name = "mycrate";
  src = lib.cleanSource ./.;
  nativeBuildInputs = [
    pkg-config
  ];
  buildInputs = runtime-deps;
  passthru.runtime-deps = runtime-deps;
  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
    };
  };
}
