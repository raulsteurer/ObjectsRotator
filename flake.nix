{
  description = "Objects Rotator: A High-Performance 3D Object Visualization and Rotation App";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      # Systems supported
      allSystems = [
        "x86_64-linux" # 64-bit Intel/AMD Linux
        "aarch64-linux" # 64-bit ARM Linux
        "x86_64-darwin" # 64-bit Intel macOS
        "aarch64-darwin" # 64-bit ARM macOS
      ];

      forAllSystems = f: nixpkgs.lib.genAttrs allSystems (system: f {
        pkgs = import nixpkgs { inherit system; };
      });
    in
    {
      packages = forAllSystems ({ pkgs }: {
        default =
          let
            binName = "objectsRotator";
            cDependencies = with pkgs; [ gcc SDL2 ];
          in
          pkgs.stdenv.mkDerivation {
            name = "objectsRotator";
            src = self;
            buildInputs = cDependencies;
            buildPhase = ''
              gcc -Wall -Wpedantic -g -I src -O3 src/*.c -o ${binName} -lSDL2 -lm
            '';
            installPhase = ''
              mkdir -p $out/bin
              cp ${binName} $out/bin/
            '';
          };
      });
    };

}
