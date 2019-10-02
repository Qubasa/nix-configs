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

  nix-test = pkgs.writeScriptBin "nix-test" ''
    #!/bin/sh

     VM=$(/run/current-system/sw/bin/nixos-rebuild --fast build-vm 2>&1 | ${pkgs.coreutils}/bin/tail -n1 | ${pkgs.gawk}/bin/awk '{ print $10 }')
     echo "$VM"
      "$VM" -m 2G,maxmem=4G -smp 4
  '';


  pdf = pkgs.writeScriptBin "pdf" ''
    #!/bin/sh
    export PATH=$PATH:${pkgs.coreutils}/bin
    ${pkgs.firefox}/bin/firefox &
    '';

  disks = pkgs.writeScriptBin "disks" ''
    #!/bin/sh
    export PATH=$PATH:${pkgs.coreutils}/bin
    nohup ${pkgs.gnome3.gnome-disk-utility}/bin/gnome-disks > /tmp/disks.log &
  '';


  wcd = pkgs.writeScript "wcd" ''
#!/bin/sh

export PATH=$PATH:${pkgs.coreutils}/bin

cd "$(readlink "$(${pkgs.which}/bin/which --skip-alias "$1")" | ${pkgs.findutils}/bin/xargs dirname)/.."
    '';

  where = pkgs.writeScript "where.sh" ''
#!/bin/sh

export PATH=$PATH:${pkgs.coreutils}/bin

${pkgs.coreutils}/bin/readlink "$(${pkgs.which}/bin/which --skip-alias "$1")" | ${pkgs.findutils}/bin/xargs ${pkgs.coreutils}/bin/dirname
    '';
in {
  environment.shellAliases = {
    # Default aliases
    l = "ls -alh";
    vim = "nvim";
    m = "micro";
    ls = "ls --color=tty";
    ll = "ls -l";
    sudo = "sudo ";
    rsync = ''${pkgs.rsync}/bin/rsync -Pav -e "ssh -i ${config.mainUserHome}/.ssh/id_rsa -F ${config.mainUserHome}/.ssh/config"'';

    # Convenience aliases
    qrcode = "${pkgs.qrencode}/bin/qrencode -t UTF8";
    packtar = "tar czvf";
    untar = "tar xvfz";
    music = "${pkgs.moc}/bin/mocp";
    disk-usage = "${pkgs.ncdu}/bin/ncdu";
    share-dir = "${pkgs.python3}/bin/python3 -m http.server 1234";
    t = "${pkgs.taskwarrior}/bin/task";
    video = "mpv --keep-open --really-quiet --pause";
    wifi = "${pkgs.iwd}/bin/iwctl";
    img = "imv";
    screenshot = "grim";
    logout-wayland = "kill -9 -1";


    # Search aliases
    search-file = ''${pkgs.fzf}/bin/fzf --preview="head -n $LINES {}" '';
    search-string = "${pkgs.gnugrep}/bin/grep -rnw -e";

    # Nix aliases
    nix-rebuild = "nixos-rebuild --fast --show-trace switch";
    nix-profiles = "nix-env --list-generations";
    nix-delete-old = "nix-collect-garbage -d && journalctl --vacuum-time=2d";
    nix-update = "nix-channel --update && nixos-rebuild switch";
    aliases = "${pkgs.less}/bin/less /etc/nixos/aliases.nix";

    # Needed to overwrite the alias binary 'where' of which
    where = "${where}";
    wcd = "source ${wcd}";

    # Shorcuts help
    shortcuts-shell = "cat /etc/nixos/resources/shortcuts-help/shell.txt";
    shortcuts-i3 = "cat /etc/nixos/resources/shortcuts-help/i3.txt";
    shortcuts-vim = "cat /etc/nixos/resources/shortcuts-help/nvim.txt";
    shortcuts-tmux = "cat /etc/nixos/resources/shortcuts-help/tmux.txt";

    # Clipboard aliases
    c = "${pkgs.wl-clipboard}/bin/wl-copy"; # Copy to clipboard
    v = "${pkgs.wl-clipboard}/bin/wl-copy -o"; # Paste

    fromByte = "${pkgs.coreutils}/bin/numfmt --to=iec";
    toByte = "${pkgs.coreutils}/bin/numfmt --from=iec";
  };

  environment.systemPackages = with pkgs; [
    nix-test
    pdf
    disks
    kbd_backlight
  ];
}
