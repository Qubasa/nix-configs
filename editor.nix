{ pkgs, ... }:

let
  extensions = (with pkgs.vscode-extensions; [
    jnoortheen.nix-ide
    rust-lang.rust-analyzer
    ms-python.python
   # ms-azuretools.vscode-docker
    redhat.java
    yzhang.markdown-all-in-one
    timonwong.shellcheck
    tamasfe.even-better-toml
    serayuzgur.crates
    ms-vscode-remote.remote-ssh
    vadimcn.vscode-lldb
    github.github-vscode-theme
    james-yu.latex-workshop
    llvm-vs-code-extensions.vscode-clangd
    ms-toolsai.jupyter
    valentjn.vscode-ltex
    ms-vsliveshare.vsliveshare
  ]) ++ (with pkgs.unstable.pkgs.vscode-extensions; [
    twxs.cmake
    github.copilot
  ]) ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
    {
      name = "cargo";
      publisher = "panicbit";
      version = "0.2.3";
      sha256 = "sha256-B0oLZE8wtygTaUX9/qOBg9lJAjUUg2i7B2rfSWJerEU=";
    }
    {
      name = "copilot-labs";
      publisher = "github";
      version = "0.12.791";
      sha256 = "sha256-3StswisTiG1e+LZeAuquIXlqaFj0Lzk4WNy+6Af4giw=";
    }
    {
      name = "veriloghdl";
      publisher = "mshr-h";
      version = "1.7.0";
      sha256 = "sha256-nGDogMHbkenECBW/06ZjualaSHnzntXPVmU9Dn5G3aI=";
    }
    {
      name = "bookmarks";
      publisher = "alefragnani";
      version = "13.2.2";
      sha256 = "sha256-pdZi+eWLPuHp94OXpIlOOS29IGgze4dNd4DWlCGa3p0=";
    }
    {
      name = "highlight-trailing-white-spaces";
      publisher = "ybaumes";
      version = "0.0.2";
      sha256 = "sha256-wuF4ieegQmH8vjMHcoDYmGmR/qQKdeW5sDW83r7eGAY=";
    }
    {
      name = "vscode-talonscript";
      publisher = "mrob95";
      version = "0.3.8";
      sha256 = "sha256-i22kEWGj8wdpkp+x/kU6vQ/IBQ4solLSIlFUNRRoKMo=";
    }
    {
      name = "linkerscript";
      publisher = "zixuanwang";
      version = "1.0.2";
      sha256 = "sha256-J6j4tXJ+gQWGJnMiqoIqJT2kGs/m8Njjm9pX9NCvJWc=";
    }
    {
      name = "language-x86-64-assembly";
      publisher = "13xforever";
      version = "3.0.0";
      sha256 = "sha256-wIsY6Fuhs676EH8rSz4fTHemVhOe5Se9SY3Q9iAqr1M=";
    }
    {
      name = "llvm";
      publisher = "rreverser";
      version = "0.1.1";
      sha256 = "sha256-MPY854kj34ijQqAZQCSvdszanBPYzxx1D7m+3b+DqGQ=";
    }
    {
      name = "talon";
      publisher = "pokey";
      version = "0.2.0";
      sha256 = "sha256-BPc0jGGoKctANP4m305hoG9dgrhjxZtFdCdkTeWh/Xk=";
    }
    {
      name = "vscode-fileutils";
      publisher = "sleistner";
      version = "3.4.5";
      sha256 = "sha256-ZzqYt9rkpeKKLhruyK5MQFlBaCZFnv2NYQvBM0YEtjg=";
    }
    {
      name = "command-server";
      publisher = "pokey";
      version = "0.8.2";
      sha256 = "sha256-mVDXn8jygpmshr7Xxve57JV3UMci3oeeLHr5dWirkOw=";
    }
    {
      name = "remote-ssh-edit";
      publisher = "ms-vscode-remote";
      version = "0.65.6";
      sha256 = "sha256-W+XJgcMjky9fFLEgnk3Jef4HvhwfBonhVoVjCGYJtIo=";
    }
/*     {
      name = "vscode-coverage-gutters";
      publisher = "ryanluker";
      version = "2.8.2";
      sha256 = "sha256-gMzFI0Z9b7I7MH9v/UC7dXCqllmXcqHVJU7xMozmMJc=";
    } */
  ];
  vscode-with-extensions = pkgs.vscode-with-extensions.override {
    vscode = pkgs.vscode;
    vscodeExtensions = extensions;
  };


in
{
  environment.variables = {
    EDITOR = [ "code" ];
    VISUAL = [ "code" ];
  };

  environment.systemPackages = with pkgs; [
    vscode-with-extensions
  ];
}
