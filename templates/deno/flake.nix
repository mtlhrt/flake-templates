{
  description = "a basic Deno development environment with Nix.";
  inputs.nixpkgs.url = "github:nixos/nixpkgs/release-26.05";
  outputs = { nixpkgs, ... }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" ];
      eachSystem = fn:
        nixpkgs.lib.genAttrs systems
        (system: fn nixpkgs.legacyPackages.${system});
    in {
      devShells = eachSystem (pkgs: {
        default = pkgs.mkShellNoCC {
          buildInputs = with pkgs; [
            nil
            nixfmt-classic
            deno
            just
            nodePackages.prettier
          ];
        };
      });
    };
}
