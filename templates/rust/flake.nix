{
  inputs = {
    rust-overlay.url = "github:oxalica/rust-overlay";
    rust-overlay.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, rust-overlay, ... } @ inputs:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      overlays = [ rust-overlay.overlays.default ];
    };
    rust-build = pkgs.rust-bin.stable.latest.default.override {
      extensions = [ "rust-src" ];
      targets = [];
    };
    rustPlatform = pkgs.makeRustPlatform {
      rustc = rust-build;
      cargo = rust-build;
    };
    mycrate = pkgs.callPackage ./package.nix {
      inherit rustPlatform;
    };
  in
  {
    devShell.${system} = pkgs.mkShell {
      packages = with pkgs; [
        git
        cargo-edit
        cargo-watch
        rust-analyzer-unwrapped
      ];
      inputsFrom = [
        mycrate
      ];
      RUST_SRC_PATH = "${rust-build}/lib/rustlib/src/rust/library";
      LD_LIBRARY_PATH = "${pkgs.lib.makeLibraryPath mycrate.runtime-deps}";
    };
    packages.${system}.default = mycrate;
  };
}
