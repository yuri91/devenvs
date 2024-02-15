{ lib
, pkgs
, mkShell
}:
let
  rust-build = pkgs.rust-bin.stable.latest.default.override {
    extensions = [ "rust-src" "rust-analyzer" "rustfmt" "llvm-tools" ];
    targets = ["thumbv7em-none-eabihf"];
  };
in
mkShell {
  packages = with pkgs; [
    git
    cargo-edit
    rust-build
    clang_16
    cmake
    ninja
    cmakeCurses
    gcc
    openssl
  ];
  RUST_SRC_PATH = "${rust-build}/lib/rustlib/src/rust/library";
}
