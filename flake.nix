{
  description = "OCaml package generator";

  outputs = { self, nixpkgs }:
    let
      systems = [ "aarch64-linux" "x86_64-linux" ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f system);
    in {

      packages = forAllSystems (system: {
        opam2nix = nixpkgs.legacyPackages.${system}.callPackage ./nix {
          self = self.outPath;
        };
      });

      defaultPackage = forAllSystems (system: self.packages.${system}.opam2nix);

      apps = forAllSystems (system: {
        opam2nix = let pkg = self.packages.${system}.opam2nix;
        in {
          type = "app";
          program = "${pkg}/bin/opam2nix";
        } // pkg.passthru;
      });

      defaultApp = forAllSystems (system: self.apps.${system}.opam2nix);

      checks = forAllSystems (system: {
        builder = import ./test.nix {
          pkgs = nixpkgs.legacyPackages.${system};
          opam2nix = self.defaultPackage.${system};
        };
      });

    };
}
