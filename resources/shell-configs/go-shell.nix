with import <nixpkgs> {};
stdenv.mkDerivation rec {
  name = "env";
  env = buildEnv { name = name; paths = buildInputs; };
  buildInputs = [
    go
    delve
  ];

  shellHook = ''
  export GOPATH=$(pwd)/go_packages
  export GOBIN=$GOPATH/bin
  export PATH=$PATH:$GOBIN

  '';

}
