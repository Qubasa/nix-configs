{ stablepkgs, pkgs, ... }:

let
  extensions = (with pkgs.vscode-extensions; [
    jnoortheen.nix-ide
    rust-lang.rust-analyzer
    eamodio.gitlens
    yzhang.markdown-all-in-one
    serayuzgur.crates
    ms-vscode-remote.remote-ssh
    vadimcn.vscode-lldb
    github.github-vscode-theme
    james-yu.latex-workshop
    llvm-vs-code-extensions.vscode-clangd
    valentjn.vscode-ltex # spell checker
    ms-vsliveshare.vsliveshare
    twxs.cmake
  # Extensions that are broken on unstable
  ])++ (with stablepkgs.vscode-extensions; [
    ms-python.python
    ms-toolsai.jupyter
  ]) ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
    {
      name = "weaudit";
      publisher = "trailofbits";
      version = "1.1.0";
      sha256 = "sha256-XHif6JzZJvQiToIn3mnBznp9ct8wlWOyBVncHU4ZDgo=";
    }
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
      version = "3.10.3";
      sha256 = "sha256-v9oyoqqBcbFSOOyhPa4dUXjA2IVXlCTORs4nrFGSHzE=";
    }
    {
      name = "remote-ssh-edit";
      publisher = "ms-vscode-remote";
      version = "0.86.0";
      sha256 = "sha256-JsbaoIekUo2nKCu+fNbGlh5d1Tt/QJGUuXUGP04TsDI=";
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
