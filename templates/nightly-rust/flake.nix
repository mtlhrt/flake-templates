{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    parts.url = "github:hercules-ci/flake-parts";
    naersk.url = "github:nix-community/naersk";
    rust = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "utils";
    };
  };
  outputs = inputs@{ nixpkgs, parts, rust, treefmt-nix, naersk, ... }:
    parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" "aarch64-linux" ];

      perSystem = { system, ... }:
        let
          overlays = [ (import rust) ];
          pkgs = import nixpkgs { inherit system overlays; };
          rustToolchain = pkgs.pkgsBuildHost.rust-bin.fromRustupToolchainFile
            ./rust-toolchain.toml;
          naersk-lib = pkgs.callPackage naersk { };
        in {
          devShells.default = pkgs.mkShell {
            packages = with pkgs; [ rustToolchain just bacon ];
          };
          packages.default = naersk-lib.buildPackage { src = ./.; };
        };
    };
}
