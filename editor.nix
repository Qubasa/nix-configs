{ stablepkgs, pkgs, ... }:

let
  extensions = (with pkgs.vscode-extensions; [
    jnoortheen.nix-ide
    rust-lang.rust-analyzer
    eamodio.gitlens
    yzhang.markdown-all-in-one
    timonwong.shellcheck
    tamasfe.even-better-toml
    serayuzgur.crates
    ms-vscode-remote.remote-ssh
    vadimcn.vscode-lldb
    github.github-vscode-theme
    james-yu.latex-workshop
    llvm-vs-code-extensions.vscode-clangd
    valentjn.vscode-ltex
    ms-vsliveshare.vsliveshare
    bradlc.vscode-tailwindcss
    esbenp.prettier-vscode
    alefragnani.bookmarks
    twxs.cmake
    github.copilot

  # Extensions that are broken on unstable
  ])++ (with stablepkgs.vscode-extensions; [
    ms-python.python
    ms-toolsai.jupyter
  ]) ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
    {
      name = "cargo";
      publisher = "panicbit";
      version = "0.2.3";
      sha256 = "sha256-B0oLZE8wtygTaUX9/qOBg9lJAjUUg2i7B2rfSWJerEU=";
    }
    {
      name = "highlight-trailing-white-spaces";
      publisher = "ybaumes";
      version = "0.0.2";
      sha256 = "sha256-wuF4ieegQmH8vjMHcoDYmGmR/qQKdeW5sDW83r7eGAY=";
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
      name = "vscode-fileutils";
      publisher = "sleistner";
      version = "3.4.5";
      sha256 = "sha256-ZzqYt9rkpeKKLhruyK5MQFlBaCZFnv2NYQvBM0YEtjg=";
    }
    {
      name = "remote-ssh-edit";
      publisher = "ms-vscode-remote";
      version = "0.65.6";
      sha256 = "sha256-W+XJgcMjky9fFLEgnk3Jef4HvhwfBonhVoVjCGYJtIo=";
    }
  ];
  vscode-with-extensions = pkgs.vscode-with-extensions.override {
    vscode = pkgs.vscode;
    vscodeExtensions = extensions;
  };


in
{
  environment.variables = {
    EDITOR = [ "hx" ];
    VISUAL = [ "code" ];
  };

  environment.systemPackages = with pkgs; [
    vscode-with-extensions
  ];
}
