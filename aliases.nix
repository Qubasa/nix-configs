{ config, pkgs, ... }:

let

  kbd_backlight = pkgs.writeScriptBin "backlight-kbd" ''
    #!/bin/sh

    export PATH=${pkgs.acpilight}/bin/xbacklight:$PATH

     LIGHT=$(xbacklight -ctrl tpacpi::kbd_backlight -get)

      if [ "$LIGHT" -gt "0" ]; then
        sudo xbacklight -ctrl tpacpi::kbd_backlight -set 0
      else
        sudo xbacklight -ctrl tpacpi::kbd_backlight -set 100
      fi

    '';

  stopwatch = pkgs.writeScriptBin "stopwatch" ''
    #!/bin/sh

    now=$(date +%s)sec
    while true; do
       printf "%s\r" $(TZ=UTC date --date now-$now +%H:%M:%S.%N)
       sleep 0.1
    done
  '';

  disks = pkgs.writeScriptBin "disks" ''
    #!/bin/sh
    export PATH=$PATH:${pkgs.coreutils}/bin
    nohup ${pkgs.gnome3.gnome-disk-utility}/bin/gnome-disks > /dev/zero &
  '';

  screenshot = pkgs.writeScriptBin "screenshot" ''
  #!/bin/sh

   grim -g "$(${pkgs.slurp}/bin/slurp)" $(${pkgs.xdg-user-dirs}/bin/xdg-user-dir PICTURES)/$(date +'%s_grim.png')

  '';

  where = pkgs.writeScript "where.sh" ''
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

  x11-spawn = pkgs.writeScriptBin "x11-spawn" ''
    #!/bin/sh

    export WAYLAND_DISPLAY=""
    export DISPLAY=:0
    "$@"
  '';


in {
  environment.shellAliases = {
    # Default aliases
    l = "ls -alh";
    ls = "ls --color=tty";
    ll = "ls -l";
    sudo = "sudo ";
    rsync = ''${pkgs.rsync}/bin/rsync -Pav -e "ssh -i ${config.mainUserHome}/.ssh/id_rsa -F ${config.mainUserHome}/.ssh/config"'';

    # Convenience aliases
    qrcode = "${pkgs.qrencode}/bin/qrencode -t UTF8";
    packtar = "tar czvf";
    untar = "tar xvfz";
    music = "mocp";
    disk-usage = "${pkgs.ncdu}/bin/ncdu";
    share-dir = "${pkgs.python3}/bin/python3 -m http.server 1234";
    t = "${pkgs.taskwarrior}/bin/task";
    video = "mpv --keep-open --really-quiet --pause";
    audio-ctrl = "nohup pavucontrol";
    wifi = "${pkgs.iwd}/bin/iwctl";
    img = "imv";
    logout = "kill -9 -1";
    pdf = "evince";


    # Search aliases
    search-file = ''${pkgs.fzf}/bin/fzf --preview="head -n $LINES {}" '';
    search-string = "${pkgs.gnugrep}/bin/grep -rnw -e";
    search-npm = "nix-env -qaPA 'nixos.nodePackages'";

    # Nix aliases
    nix-rebuild = "nixos-rebuild --fast --show-trace switch";
    nix-profiles = "nix-env --list-generations";
    nix-delete-old = "nix-collect-garbage -d && journalctl --vacuum-time=2d";
    nix-update = "nix-channel --update && nixos-rebuild switch";
    aliases = "${pkgs.less}/bin/less /etc/nixos/aliases.nix";
    n = "nix-shell --command zsh";

    # Needed to overwrite the alias binary 'where' of which
    where = "${where}";
    wcd = "source ${wcd}";

    # Clipboard aliases
    c = "wl-copy"; # Copy to clipboard
    v = "wl-paste"; # Paste

    fromByte = "${pkgs.coreutils}/bin/numfmt --to=iec";
    toByte = "${pkgs.coreutils}/bin/numfmt --from=iec";
  };

  environment.systemPackages = with pkgs; [
    stopwatch
    x11-spawn
    disks
    screenshot
    kbd_backlight
  ];
}
