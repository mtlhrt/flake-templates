{
  inputs = { nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable"; };
  outputs = { nixpkgs, ... }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" ];
      eachSystem = f:
        nixpkgs.lib.genAttrs systems
        (system: f nixpkgs.legacyPackages.${system});
    in {
      devShells = eachSystem (pkgs: {
        default =
          pkgs.mkShell { buildInputs = with pkgs; [ gleam erlang just ]; };
      });
    };
}
