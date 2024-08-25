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
    in
    {
      devShells.${system} = {
        default = pkgs.callPackage ./shells { };
        musl = pkgs.callPackage ./shells/musl.nix { };
        sphinx = pkgs.callPackage ./shells/sphinx.nix { };
        pandas = pkgs.callPackage ./shells/pandas.nix { };
      };
      templates = {
        rust = {
          path = ./templates/rust;
          description = "simple rust template";
          welcomeText = ''
            Change the name <mycrate> to your crate name
          '';
        };
      };
    };
}
