{
  description = "PHPStan Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    phpstan-src = {
      url = "github:phpstan/phpstan";
      flake = false;
    };
  };

  outputs = inputs @ {
    flake-parts,
    phpstan-src,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-darwin"
        "x86_64-linux"
      ];
      perSystem = {
        config,
        self',
        inputs',
        pkgs,
        system,
        lib,
        ...
      }: let
        php = pkgs.php.buildEnv {
          extraConfig = ''
            memory_limit=-1
          '';
        };

        phpstan = pkgs.stdenv.mkDerivation {
          name = "phpstan";

          src = phpstan-src;

          dontUnpack = true;

          nativeBuildInputs = [pkgs.makeBinaryWrapper php];

          installPhase = ''
            runHook preInstall

            mkdir -p $out/bin
            makeWrapper ${php}/bin/php $out/bin/phpstan --add-flags "$src/phpstan.phar"

            runHook postInstall
          '';

          meta.mainProgram = "phpstan";
        };
      in {
        formatter = pkgs.alejandra;

        apps = {
          default = {
            type = "app";
            program = phpstan;
          };
        };
      };
    };
}
#   outputs = { self, flake-utils, nixpkgs, phpstan-src }:
#     flake-utils.lib.eachDefaultSystem (system:
#       let
#         pkgs = import nixpkgs {
#           inherit system;
#         };
#       in {
#         apps = flake-utils.lib.flattenTree {
#           default = {
#             type = "app";
#             program = "${self.packages.${system}.default}";
#           };
#         };
#         packages = flake-utils.lib.flattenTree {
#           default = phpstan;
#         };
#         devShells = {
#           default = pkgs.mkShellNoCC {
#             name = "PHPStan";
#             buildInputs = [
#               self.packages.${system}.default
#             ];
#           };
#         };
#       }
#     );
# }

