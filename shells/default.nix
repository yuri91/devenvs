{ lib
, pkgs
, mkShell
}:
let
  rust-build = pkgs.rust-bin.stable.latest.default.override {
    extensions = [ "rust-src" "rust-analyzer" "rustfmt" "llvm-tools" ];
    targets = [ "thumbv7em-none-eabihf" ];
  };
in
mkShell {
  packages = with pkgs; [
    bashInteractive
    git
    cargo-edit
    rust-build
    clang_18
    llvmPackages_18.bintools
    cmake
    meson
    gdb
    valgrind
    ninja
    cmakeCurses
    gcc
    openssl
    pkg-config
  ];
  RUST_SRC_PATH = "${rust-build}/lib/rustlib/src/rust/library";
  hardeningDisable = [ "all" ];
}
