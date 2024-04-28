{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    utils.url = "github:numtide/flake-utils";
    parts.url = "github:hercules-ci/flake-parts";
    rust = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "utils";
    };
    crane = {
      url = "github:ipetkov/crane";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = inputs@{ nixpkgs, parts, utils, rust, crane, treefmt-nix, ... }:
    parts.lib.mkFlake { inherit inputs; } {
      systems = utils.lib.defaultSystems;

      perSystem = { pkgs, system, ... }:
        let
          pname = "nightly-rust";
          pkgs = nixpkgs.legacyPackages.${system}.extends rust.overlays.default;
          rustToolchain = pkgs.pkgsBuildHost.rust-bin.fromRustupToolchainFile
            ./rust-toolchain.toml;
          craneLib = (crane.mkLib pkgs).overrideToolchain rustToolchain;
          src = craneLib.cleanCargoSource (craneLib.path ./.);
          commonArgs = {
            inherit pname src;
            strictDeps = true;
            version = "0.1";
          };
          cargoArtifacts = craneLib.buildDepsOnly commonArgs;
          bin =
            craneLib.buildPackage (commonArgs // { inherit cargoArtifacts; });
          treeFmtEval = treefmt-nix.lib.evalModule pkgs ./treefmt.nix;
        in {
          devShells.default = craneLib.devShell {
            inputsFrom = [ bin ];
            packages = with pkgs; [ just bacon ];
          };

          packages.default = bin;

          apps.default = utils.lib.mkApp { drv = bin; };

          checks = {
            inherit bin;
            fmt = craneLib.cargoFmt { inherit src; };
            clippy =
              craneLib.cargoClippy (commonArgs // { inherit cargoArtifacts; });
          };

          formatter = treeFmtEval.config.build.wrapper;
        };
    };
}
