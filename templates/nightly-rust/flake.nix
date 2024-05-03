{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    treefmt-nix.url = "github:numtide/treefmt-nix";
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
          treeFmtEval = treefmt-nix.lib.evalModule pkgs ./treefmt.nix;
          naersk' = pkgs.callPackage naersk { };
        in {
          devShells.default = pkgs.mkShell {
            packages = with pkgs; [ rustToolchain just bacon ];
          };
          packages.default = naersk'.buildPackage { src = ./.; };
          formatter = treeFmtEval.config.build.wrapper;
        };
    };
}
