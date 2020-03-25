{ pkgs ? import <nixpkgs> { }

, opam2nix ? import (builtins.fetchTarball
  "https://github.com/timbertson/opam2nix/archive/v1.tar.gz") { } }:

with pkgs;

runCommand "opam2nix-test" {
  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = pkgs.lib.fakeSha256;
  buildInputs = [ opam2nix ];

  SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";
  GIT_SSL_CAINFO = "${cacert}/etc/ssl/certs/ca-bundle.crt";

  impureEnvVars = lib.fetchers.proxyImpureEnvVars
    ++ [ "GIT_PROXY_COMMAND" "SOCKS_SERVER" ];

} ''
  export HOME=$NIX_BUILD_TOP
  mkdir $out; cd $out
  opam2nix resolve  --ocaml-version ${ocaml.version} sexplib
''
