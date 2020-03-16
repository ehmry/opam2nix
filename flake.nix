{
  description = "OCaml package generator";

  edition = 201909;

  outputs = { self, nixpkgs }:
    let
      pkg = nixpkgs.legacyPackages.x86_64-linux.callPackage ./nix {
        self = self.outPath;
      };
    in {
      packages.x86_64-linux.opam2nix = pkg;

      defaultPackage.x86_64-linux = pkg;

      apps.x86_64-linux.opam2nix = {
        type = "app";
        program = "${pkg}/bin/opam2nix";
      } // pkg.passthru;

      defaultApp.x86_64-linux = self.apps.x86_64-linux.opam2nix;
    };
}
