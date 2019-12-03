{ nixpkgs ? import <nixpkgs> {}, compiler ? "default", doBenchmark ? false }:

let
  pkgs = let
    hostPkgs = import <nixpkgs> {};
    pinnedVersion = hostPkgs.lib.importJSON ./nixpkgs-version.json;
    pinnedPkgs = hostPkgs.fetchFromGitHub {
      owner = "NixOS";
      repo = "nixpkgs-channels";
      inherit (pinnedVersion) rev sha256;
    };
  in import pinnedPkgs {};

  f = { mkDerivation, base, hashable, haskell-names
      , haskell-src-exts, stdenv, syb
      }:
      mkDerivation {
        pname = "hs-all-in-one";
        version = "0.1";
        src = ./.;
        isLibrary = false;
        isExecutable = true;
        executableHaskellDepends = [
          base hashable haskell-names haskell-src-exts syb
        ];
        homepage = "http://github.com/nomeata/hs-all-in-one";
        description = "Merges multiple Haskell modules into one";
        license = stdenv.lib.licenses.mit;
      };

  haskellPackages = if compiler == "default"
                       then pkgs.haskellPackages
                       else pkgs.haskell.packages.${compiler};

  variant = if doBenchmark then pkgs.haskell.lib.doBenchmark else pkgs.lib.id;

  drv = variant (haskellPackages.callPackage f {});

in

  if pkgs.lib.inNixShell then drv.env else drv
