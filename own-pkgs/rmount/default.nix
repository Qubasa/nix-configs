{ stdenv, fetchgit, makeWrapper, lib, pkgs ? import <nixpkgs> {} }:
with pkgs;

stdenv.mkDerivation rec {
  name    = "rmount-${version}";
  version = "1.0.1";
  rev = "v${version}";

  src = fetchgit {
    rev = "9df124780d2e66f01c70afaecf92090669c5ffb6";
    url    = "https://github.com/Luis-Hebendanz/rmount";
    sha256 = "0ydb6sspfnfa3y6gg1r8sk4r58il6636lpqwb2rw7dzmb4b8hpd2";
  };

  buildInputs = [ stdenv makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/share/man/man1
    cp ${src}/rmount.man $out/share/man/man1/rmount.1
    cp ${src}/rmount.bash $out/bin/rmount-noenv
    cp ${src}/config.json $out/share/config.json
    chmod +x $out/bin/rmount-noenv

    makeWrapper $out/bin/rmount-noenv $out/bin/rmount \
    --prefix PATH : ${lib.makeBinPath [ nmap jq cifs-utils sshfs ]}
  '';

  meta = {
      homepage = "https://github.com/Luis-Hebendanz/rmount";
      description = "Remote mount utility which parses a json file";
      license = stdenv.lib.licenses.mit;
    };
}
