{ pkgs ? import <nixpkgs> {}, stdenv ? pkgs.stdenv, fetchFromGitHub ? pkgs.fetchFromGitHub, buildGoPackage ? pkgs.buildGoPackage}:
buildGoPackage rec {
  name = "ops-${version}";
  version = "0.1.10";
  goPackagePath = "github.com/nanovms/ops";  # Incomplete
  src = fetchFromGitHub {
   owner = "nanovms";
   repo="ops";
   rev = "${version}";
   sha256 = "1hqdil6cdjp0q8ilqbhvy9qkh24402p9skc22aqni89i2hdzcw3g";
  };  # Incomplete
  goDeps = ./deps.nix;

  meta = with stdenv.lib; {
    description = "A tool for creating and running a Nanos unikernel";
    homepage = "https://github.com/nanovms/ops";
    license = licenses.mit;
    maintainers = with maintainers; [ luis-hebendanz ];
  };
}

