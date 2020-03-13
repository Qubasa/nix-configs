{ pkgs ? import <nixpkgs> {} }:

with pkgs;
stdenv.mkDerivation {
  name = "nixos-generators";
  src = builtins.fetchGit {
      url = "https://github.com/nix-community/nixos-generators.git";
      rev = "942232e3000e80b4b4ad34cb3c07923415c27493";
  };
  nativeBuildInputs = [ makeWrapper ];
  installFlags = [ "PREFIX=$(out)" ];
  postFixup = ''
    wrapProgram $out/bin/nixos-generate \
      --prefix PATH : ${lib.makeBinPath [ jq coreutils findutils nix ] }
  '';
}
