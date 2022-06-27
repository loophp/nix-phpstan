{
  description = "PHPStan Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    flake-utils.inputs.nixpkgs.follows = "nixpkgs";
    phpstan-src = {
      url = "github:phpstan/phpstan/1.7.x";
      flake = false;
    };
  };

  outputs = { self, flake-utils, nixpkgs, phpstan-src }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };

        phpstan = pkgs.stdenv.mkDerivation {
          name = "phpstan";

          src = phpstan-src;

          dontUnpack = true;

          nativeBuildInputs = [ pkgs.makeWrapper ];

          installPhase = ''
            runHook preInstall
            mkdir -p $out/bin
            install -D $src/phpstan.phar $out/bin/
            makeWrapper ${pkgs.php}/bin/php $out/bin/phpstan \
              --add-flags "$out/bin/phpstan.phar"
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
      }
    );

}
