{
  description = "a tModloader 1.4.4 mod project.";
  inputs.nixpkgs.url = "github:nixos/nixpkgs/release-26.05";
  outputs = { nixpkgs, ... }:
    let
      inherit (nixpkgs) lib;
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in {
      devShells.${system}.default = pkgs.mkShell {
        LD_LIBRARY_PATH = lib.makeLibraryPath [ pkgs.fna3d ];
        buildInputs = with pkgs;
          let
            tModDeps = [ mono dotnet-sdk ];
            devDeps = [ nil nixfmt omnisharp-roslyn ];
          in tModDeps ++ devDeps;
      };
    };
}
