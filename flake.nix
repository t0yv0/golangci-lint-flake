{
  description = "A flake defining golangci-linux binary package via GitHub releases";

  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-22.05;
    golangci-lint-x86_64-linux = {
      url = "https://github.com/golangci/golangci-lint/releases/download/v1.50.1/golangci-lint-1.50.1-linux-amd64.tar.gz";
      flake = false;
    };
    golangci-lint-x86_64-darwin = {
      url = "https://github.com/golangci/golangci-lint/releases/download/v1.50.1/golangci-lint-1.50.1-darwin-amd64.tar.gz";
      flake = false;
    };
  };

  outputs =
    { self,
      nixpkgs,
      golangci-lint-x86_64-linux,
      golangci-lint-x86_64-darwin,
    }:

    let
      package = { system, src }:
        let
          pkgs = import nixpkgs { system = system; };
        in pkgs.stdenv.mkDerivation {
          name = "golangci-lint-1.50.1";
          version = "1.50.1";
          src = src;
          installPhase = "mkdir -p $out/bin && cp $src/golangci-lint $out/bin/";
        };
    in {
      packages.x86_64-linux.default = package {
        system = "x86_64-linux";
        src = golangci-lint-x86_64-linux;
      };
      packages.x86_64-darwin.default = package {
        system = "x86_64-darwin";
        src = golangci-lint-x86_64-darwin;
      };
    };
}
