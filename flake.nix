{
  description = "PHPStan Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    flake-utils.inputs.nixpkgs.follows = "nixpkgs";
    phpstan-src = {
      url = "github:phpstan/phpstan";
      flake = false;
    };
  };

  outputs = { self, flake-utils, nixpkgs, phpstan-src }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };

        php = pkgs.php.buildEnv {
          extraConfig = ''
            memory_limit=-1
          '';
        };

        phpstan = pkgs.stdenv.mkDerivation {
          name = "phpstan";

          src = phpstan-src;

          dontUnpack = true;

          nativeBuildInputs = [ pkgs.makeWrapper php ];

          installPhase = ''
            runHook preInstall
            mkdir -p $out/bin
            makeWrapper ${php}/bin/php $out/bin/phpstan --add-flags "$src/phpstan.phar"
            runHook postInstall
          '';
        };
      in {
        apps = flake-utils.lib.flattenTree {
          default = {
            type = "app";
            program = "${self.packages.${system}.default}";
          };
        };

        packages = flake-utils.lib.flattenTree {
          default = phpstan;
        };

        devShells = {
          default = pkgs.mkShellNoCC {
            name = "PHPStan";

            buildInputs = [
              self.packages.${system}.default
            ];
          };
        };
      }
    );

}
