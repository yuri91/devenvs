{
  inputs = {
    git-hooks.url = "github:cachix/git-hooks.nix";
    git-hooks.inputs.nixpkgs.follows = "nixpkgs";

    rust-overlay.url = "github:oxalica/rust-overlay";
    rust-overlay.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, rust-overlay, git-hooks, ... } @ inputs:
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
    pre-commit-check = git-hooks.lib.${system}.run {
      src = ./.;
      hooks = {
        nixpkgs-fmt.enable = true;
        rustfmt = {
          enable = true;
          packageOverrides.cargo = rust-build;
          packageOverrides.rustfmt = rust-build;
        };
        clippy = {
          enable = true;
          packageOverrides.cargo = rust-build;
          packageOverrides.clippy = rust-build;
        };
      };
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

      hardeningDisable = [ "all" ];

      inherit (pre-commit-check) shellHook;
    };
    packages.${system}.default = mycrate;
  };
}
