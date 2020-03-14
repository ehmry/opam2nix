{
  description = "OCaml package generator";

  edition = 201909;

  outputs = { self, nixpkgs }:
    let
      pkg =
        import ./default.nix { pkgs = nixpkgs.legacyPackages.x86_64-linux; };
    in {
      packages.x86_64-linux.opam2nix = pkg;
      defaultPackage.x86_64-linux.opam2nix =
        self.packages.x86_64-linux.opam2nix;

      apps.x86_64-linux.opam2nix = {
        type = "app";
        program = "${pkg}/bin/opam2nix";
      } // pkg.passthru;

      defaultApp.x86_64-linux = self.apps.x86_64-linux.opam2nix;
    };
}
