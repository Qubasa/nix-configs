{pkgs, environment, config, lib, ... }:

with pkgs;

let

  callPackage = pkgs.lib.callPackageWith (pkgs);

  wallpaper_path = ./resources/wallpapers/pixel_space.jpg;
  lock_wallpaper_path = ./resources/lockscreen.jpg;
  waybar_renderer = callPackage ./own-pkgs/waybar_renderer {};

  # This propagates root clipboard to mainUser clipboard
  wl-copy = pkgs.writeScriptBin "wl-copy" ''
   export XDG_RUNTIME_DIR="/run/user/${toString config.users.extraUsers.${config.mainUser}.uid}"
    ${wl-clipboard}/bin/wl-copy "$@"
  '';

  wl-paste = pkgs.writeScriptBin "wl-paste" ''
    export XDG_RUNTIME_DIR="/run/user/${toString config.users.extraUsers.${config.mainUser}.uid}"
    ${wl-clipboard}/bin/wl-paste "$@"
  '';

  lock_screen = pkgs.writeScriptBin "lock_screen" ''
    #!/bin/sh
    ${pkgs.swaylock}/bin/swaylock -f -e -c 000000 -i ${lock_wallpaper_path}

    '';

  weechat-connect = pkgs.writeScriptBin "weechat-connect" ''
    #!/bin/sh
    kitty --class "weechat" --name "weechat" --title "weechat" sh -c "ssh weechat -t 'tmux a; bash -l'"
  '';

  xresources = pkgs.writeText "Xresources" ''
    Xcursor.size: 16
    '';

  startsway = pkgs.writeScriptBin "startsway" ''
    #!/bin/sh

    export SDL_VIDEODRIVER=wayland
    export QT_QPA_PLATFORM=wayland
    export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
    export _JAVA_AWT_WM_NONREPARENTING=1
    export MOZ_ENABLE_WAYLAND=1

    # first import environment variables from the login manager
    systemctl --user import-environment
    # then start the service
    exec systemctl --user start sway.service
  '';

  sway_dbus = pkgs.writeScript "sway_dbus.sh" ''
    #!/bin/sh

    ${pkgs.dbus}/bin/dbus-run-session ${pkgs.sway}/bin/sway -d 2>/tmp/sway.log

    if [ "$?" != "0"  ]; then
      kill -9 -1 || shutdown now;
    fi
  '';

  random_background = pkgs.writeScriptBin "random_background" ''
    #!/bin/sh
    set -xe

    IMG=$(ls ${./resources/wallpapers} | shuf -n1)
    IMG_PATH="${./resources/wallpapers}/$IMG"
    echo "Settings background image: $IMG"
    ${pkgs.swaybg}/bin/swaybg --image "$IMG_PATH" -m stretch
  '';

in {
  programs.light.enable = true;

  programs.sway = {
    enable = true;
    extraPackages = [
      xwayland
      swaybg
      alsaUtils
      lock_screen
      mako
      # acpilight
      swayidle
      random_background
    ];
    extraSessionCommands = ''
      export SDL_VIDEODRIVER=wayland
      export QT_QPA_PLATFORM=wayland
      export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
      export _JAVA_AWT_WM_NONREPARENTING=1
      export MOZ_ENABLE_WAYLAND=1
    '';
  };

  environment = {
    etc = {
      "sway/config".source = ./resources/sway.conf;
    };
  };

  # Needed for screen sharing over browser to work
  # services.pipewire.enable = true;

  environment.systemPackages = with pkgs; [
    pkgs.unstable.wofi     # Dmenu replacement
    wl-copy
    wl-paste
	waybar_renderer
    startsway
    weechat-connect
    random_background
  ];

  systemd.user.targets.sway-session = {
    description = "Sway compositor session";
    documentation = [ "man:systemd.special(7)" ];
    bindsTo = [ "graphical-session.target" ];
    wants = [ "graphical-session-pre.target" ];
    after = [ "graphical-session-pre.target" ];
  };

  systemd.user.services.panic-logout = {
    description = "Panic logout";
    script = ''
      #!/bin/sh
      ${pkgs.utillinux}/bin/kill -9 -1 || shutdown now;
    '';
  };

  systemd.user.services.sway = {
    description = "Sway - Wayland window manager";
    documentation = [ "man:sway(5)" ];
    bindsTo = [ "graphical-session.target" ];
    wants = [ "graphical-session-pre.target" ];
    after = [ "graphical-session-pre.target" ];
    # We explicitly unset PATH here, as we want it to be set by
    # systemctl --user import-environment in startsway
    environment.PATH = lib.mkForce null;

    serviceConfig = {
      ExecStart=sway_dbus;
      Type = "simple";
    };
  };

  systemd.user.services.kanshi = {
    description = "Kanshi output autoconfig ";
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    serviceConfig = {
      ExecStart = ''
        ${pkgs.kanshi}/bin/kanshi
      '';
      RestartSec = 5;
      Restart = "always";
    };
  };

  system.activationScripts.copySwayConfig = ''

  mkdir -p ${config.mainUserHome}/.config/wofi
  ln -s -f ${./resources/wofi.conf} ${config.mainUserHome}/.config/wofi/config
  chown -h -R ${config.mainUser}: ${config.mainUserHome}/.config/wofi

  mkdir -p ${config.mainUserHome}/.config/kanshi
  ln -s -f ${./resources/kanshi.conf} ${config.mainUserHome}/.config/kanshi/config
  chown -h -R ${config.mainUser}: ${config.mainUserHome}/.config/kanshi

  # .Xresources for mouse
  ln -f -s ${xresources} ${config.mainUserHome}/.Xresources
  chown -h ${config.mainUser}: ${config.mainUserHome}/.Xresources
'';
}
