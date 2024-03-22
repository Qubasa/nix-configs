{ config, pkgs, ... }:

let

  nix-rebuild = pkgs.writeScriptBin "nix-rebuild" ''
    sudo nixos-rebuild --fast --cores 7 switch --flake /etc/nixos --impure "$@"
  '';

  nix-delete-old = pkgs.writeScriptBin "nix-delete-old" ''
    sudo nix-collect-garbage --delete-older-than 2d && sudo journalctl --vacuum-time=2d
  '';

  nix-bloat = pkgs.writeScriptBin "nix-bloat" ''
    nix-store --gc --print-roots | egrep -v "^(/nix/var|/run/\w+-system|\{memory|/proc)"
  '';

  where = pkgs.writeScriptBin "where" ''
     #!/bin/sh

     export PATH=$PATH:${pkgs.nix}/bin:${pkgs.jq}/bin:${pkgs.coreutils}/bin

     WH=$(which "$1" 2>/dev/null)
     if [ "$?" = "0" ]; then
         echo "$(readlink "$WH" | xargs dirname)/.."
     else
       DRV=$(nix-instantiate '<nixpkgs>' -A "$1" --quiet --quiet --quiet | sed 's/!dev$//g')

       if [ "$?" = "0" ]; then
         OUT=$(nix show-derivation "$DRV" | jq -r ".[\"$DRV\"].env.out")

         if [ -d "$OUT"  ]; then
             echo "$OUT"
         else
           echo "[-] Packet '$1' is not installed!"
           exit 1
         fi
       else
           echo "[-] Packet '$1' does not exist!"
           exit 1
       fi
    fi
  '';

  wcd = pkgs.writeScript "wcd" ''
     #!/bin/sh

     export PATH=$PATH:${pkgs.nix}/bin:${pkgs.jq}/bin:${pkgs.coreutils}/bin

     WH=$(which "$1")
     if [ "$?" = "0" ]; then
         cd "$(readlink "$WH" | xargs dirname)/.."
     else
       DRV=$(nix-instantiate '<nixpkgs>' -A "$1" --quiet --quiet --quiet | sed 's/!dev$//g')

       if [ "$?" = "0" ]; then
         OUT=$(nix show-derivation "$DRV" | jq -r ".[\"$DRV\"].env.out")

         if [ -d "$OUT"  ]; then
             cd "$OUT"
         else
           echo "[-] Packet '$1' is not installed!"
         fi
       else
           echo "[-] Packet '$1' does not exist!"
       fi
    fi
  '';

  rsync = pkgs.writeScriptBin "rsync" ''
    ${pkgs.rsync}/bin/rsync -Pav -e "ssh -i ${config.mainUserHome}/.ssh/id_rsa -F ${config.mainUserHome}/.ssh/config" "$@"
  '';

  # share-dir = pkgs.writeScriptBin "share-dir" ''
  #   ${pkgs.python3}/bin/python3 -m http.server 1234
  # '';

  logout = pkgs.writeScriptBin "logout" ''
    kill -9 -1
  '';

  readelf = pkgs.writeScriptBin "readelf" ''
    ${pkgs.binutils}/bin/readelf -W "$@"
  '';

  c = pkgs.writeScriptBin "c" ''
    ${pkgs.xclip}/bin/xclip -i "$@"
  '';

  v = pkgs.writeScriptBin "v" ''
    ${pkgs.xclip}/bin/xclip -o "$@"
  '';
in
{
  environment.shellAliases = {
    sudo = "sudo ";

    t = "${pkgs.taskwarrior}/bin/task";

    # Needed to overwrite the alias binary 'where' of which
    wcd = "source ${wcd}";

    fromByte = "${pkgs.coreutils}/bin/numfmt --to=iec";
    toByte = "${pkgs.coreutils}/bin/numfmt --from=iec";
  };

  environment.systemPackages = [
    v
    c
    nix-rebuild
    nix-delete-old
    where
    rsync
    # share-dir
    logout
    nix-bloat
  ];
}
