{
  inputs = {
    rust-overlay.url = "github:oxalica/rust-overlay";
    rust-overlay.inputs.nixpkgs.follows = "nixpkgs";

    naersk.url = "github:nmattia/naersk";
    naersk.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, rust-overlay, naersk, ... } @ inputs:
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
    naersk-lib = naersk.lib.${system}.override {
      rustc = rust-build;
      cargo = rust-build;
    };
    runtime-deps = with pkgs; [
    ];
    mycrate = naersk-lib.buildPackage {
      pname = "mycrate";
      root = ./.;
      buildInputs = runtime-deps;
      nativeBuildInputs = with pkgs; [
        rust-build
        pkg-config
      ];
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
      inputsFrom = with pkgs; [
        mycrate
      ];
      RUST_SRC_PATH = "${rust-build}/lib/rustlib/src/rust/library";
      LD_LIBRARY_PATH = "${pkgs.lib.makeLibraryPath runtime-deps}";
    };
    packages.${system}.default = mycrate;
  };
}
