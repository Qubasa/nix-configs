{pkgs, environment, config, lib, ... }:

with pkgs;

let

  wallpaper_path = ./resources/wallpapers/pixel_space.jpg;
  lock_wallpaper_path = ./resources/wallpapers/waterfall.jpg;
  theme_path = ./resources/sddm-slice-1.5/slice;
  rofi_config_path = ./resources/gruvbox-dark-soft.rasi;

  unstable = import <nixos-unstable> { };
  bar_update_interval = "1"; # In seconds

  i3_status_script = pkgs.writeScript "i3script.sh" ''
    #!/bin/sh

    # First time without wifi, because it blocks a long time
    BAR="$(${temp_status})"
    BAR+=" | $(${avail_disk})"
    BAR+=" | $(${volume_status})"
    BAR+=" | $(${brightness_status})"
    BAR+=" | $(${vpn_status})"
    BAR+=" | $(${eth_status})"
    BAR+=" | Wifi "
    BAR+=" | $(${date_status})"
    BAR+=" | $(${battery_status})"

    echo "$BAR"

    while true; do
      BAR="$(${temp_status})"
      BAR+=" | $(${avail_disk})"
      BAR+=" | $(${volume_status})"
      BAR+=" | $(${brightness_status})"
      BAR+=" | $(${vpn_status})"
      BAR+=" | $(${eth_status})"
      BAR+=" | $(${wifi_status})"
      BAR+=" | $(${date_status})"
      BAR+=" | $(${battery_status})"

      echo "$BAR"
      sleep ${bar_update_interval}
    done

    '';

  # TODO: Change name if you have a different vpn interface name
  vpn_status = pkgs.writeScript "vpn_status.sh" ''
    #!/bin/sh
    set -e

    export PATH="$PATH:${gawk}/bin:${acpi}/bin:${coreutils}/bin:${gnugrep}/bin:${calc}/bin"

    VPN=""
    if  [ -e "/proc/sys/net/ipv4/conf/labs-vpn" ]; then
      VPN="Labs-VPN"
    elif [ -e "/proc/sys/net/ipv4/conf/office-vpn" ]; then
      VPN="Office-VPN"
    elif [ -e "/proc/sys/net/ipv4/conf/tun0" ]; then
      VPN="UKN-VPN"
    elif [ -e "/proc/sys/net/ipv4/conf/wireguard-home" ]; then
      VPN="Home-VPN"
    elif [ -e "/proc/sys/net/ipv4/conf/home-ovpn" ]; then
      VPN="Home-VPN"
    fi

    if [ "$VPN" = "" ]; then
      echo "VPN "
    else
      echo "$VPN "
    fi
   '';

  avail_disk = pkgs.writeScript "avail_disk.sh" ''
    #!/bin/sh
    export PATH="$PATH:${gawk}/bin:${coreutils}/bin:${gnugrep}/bin"

    avail=$(df / -h | tail -n1| awk '{print $(NF-2) }')
    echo "$avail "
    '';

  wifi_status = pkgs.writeScript "wifi_status.sh" ''
    #!/bin/sh

    export PATH="$PATH:${gawk}/bin:${coreutils}/bin:${gnugrep}/bin:${wirelesstools}/bin"

    ssid=$(iwgetid -r)
    quality=$(cat /proc/net/wireless | tail -n1 | awk '{ print $3}' | sed 's/\.//g')dB

    if [ "$ssid" = "" ]; then
      echo "Wifi "
    else
      echo "$quality at $ssid "
    fi
    '';


  eth_status = pkgs.writeScript "eth_status.sh" ''
    #!/bin/sh

    export PATH="$PATH:${gawk}/bin:${coreutils}/bin:${gnugrep}/bin:${iproute}/bin"

    first_eth=$(for i in /proc/sys/net/ipv4/conf/enp*; do basename "$i"; break; done)
    status=$(ip link show dev "$first_eth" | head -n1 | awk '{ print $9 }')

    if [ "$status" = "DOWN" ]; then
      echo ""
    else
      ip_addr=$(ip address show "$first_eth" | grep inet | head -n1 | awk '{ print $2 }' | sed 's/\/24//g')
      echo "$ip_addr "
    fi

    '';

  volume_status = pkgs.writeScript "volume_status.sh" ''
    #!/bin/sh

    export PATH="$PATH:${gawk}/bin:${coreutils}/bin:${gnugrep}/bin:${alsaUtils}/bin"

    status=$(amixer sget Master | grep 'Right:' | awk -F'[][]' '{ print $4 }')
    volume=$(amixer sget Master | grep 'Right:' | awk -F'[][]' '{ print $2 }')

    if [ "$status" = "off" ]; then
      echo "Muted "
    else
      echo "$volume "
    fi
      '';

  date_status = pkgs.writeScript "date_status.sh" ''
    #!/bin/sh

    export PATH="$PATH:${gawk}/bin:${coreutils}/bin:${gnugrep}/bin"

    echo "$(date +'%d.%m.%Y    %H:%M')"
      '';

  temp_status = pkgs.writeScript "temp_status.sh" ''
    #!/bin/sh

    export PATH="$PATH:${coreutils}/bin:${calc}/bin:${lm_sensors}/bin:${gnused}/bin"

    temp=$(sensors -u 2> /dev/null| sed -n 's/_input//p' | head -n 1 | cut -f2 -d: | calc -p)
    echo "$temp "
    '';

  brightness_status = pkgs.writeScript "brightness_status.sh" ''
      #!/bin/sh

      brightness=$(${pkgs.acpilight}/bin/xbacklight -get)
      echo "$brightness% "
    '';

  battery_status = with pkgs; pkgs.writeScript "battery_status.bash" ''
    #!/bin/sh
    export PATH="$PATH:${gawk}/bin:${acpi}/bin:${coreutils}/bin:${gnugrep}/bin:${calc}/bin"

    get_battery_charging_status() {
    if [ "$(acpi -b | grep Discharging)" != "" ]; then
        echo "Discharging";
    else
        echo "Charging";
    fi
    }
    declare -a capacity_arr
    capacity_arr=(
    
    
    
    
    
    )

    # get charge of all batteries, combine them
    total_charge=$(acpi -b | awk '{print $4}' | grep -Eo "[0-9]+" | paste -sd+ | calc -p);

    # get amount of batteries in the device
    battery_number=$(acpi -b | wc -l);
    percent=$((total_charge / battery_number));
    index=$((percent / ( 100 / ''${#capacity_arr[@]}) ))

    if [ "$(get_battery_charging_status)" == "Charging" ]; then
      echo "$percent% "
    elif [ $percent -ge 98 ]; then
      echo "100% ''${capacity_arr[$index]}"
    else
      echo "$percent% ''${capacity_arr[$index]}"
    fi
  '';

  lock_screen = pkgs.writeScript "lock_screen.sh" ''
  #!/bin/sh
    ${pkgs.swaylock}/bin/swaylock -f -e -c 000000 -i ${lock_wallpaper_path}
    '';

  xresources = pkgs.writeText "Xresources" ''
    Xcursor.size: 16
    '';

  i3_conf_file =  pkgs.writeText "config" ''
    # Please see https://i3wm.org/docs/userguide.html for a complete reference!

    exec "systemctl --user import-environment; systemctl --user start sway-session.target";
    set $mod Mod4

    #######################
    #                     #
    #       LOOKS         #
    #                     #
    #######################
    # Font for window titles.
    font pango:Bitstream Vera Sans Mono 14
    font pango:Monospace 14, Icons 10
    hide_edge_borders --i3 smart
    default_floating_border pixel 3
    default_border pixel 3

    # Lockscreen shortcut
    bindsym $mod+l exec ${lock_screen}

    # start a terminal
    bindsym $mod+Return exec kitty

    # class                 border  backgr. text    indicator child_border
    client.focused          #4fceea #285577 #ffffff #2e9ef4   #285577
    client.focused_inactive #333333 #5f676a #ffffff #484e50   #5f676a
    client.unfocused        #333333 #222222 #888888 #292d2e   #222222

    #######################
    #                     #
    #   DEFAULT CONFIG    #
    #                     #
    #######################
    floating_modifier $mod
    workspace_layout tabbed
    default_orientation vertical

    # Kill focused window
    bindsym $mod+Shift+q kill

    # start dmenu (a program launcher)
    bindsym $mod+d exec ${pkgs.rofi}/bin/rofi -modi drun#run -combi-modi drun#run -show combi -show-icons -display-combi run -theme ${rofi_config_path}

    # Switch windows
    bindsym $mod+x exec ${pkgs.rofi}/bin/rofi -modi window -show window -auto-select -theme ${rofi_config_path}

    # Arrow keys for focus navigation
    bindsym $mod+Left focus left
    bindsym $mod+Down focus down
    bindsym $mod+Up focus up
    bindsym $mod+Right focus right

    # Move focused window
    bindsym $mod+Shift+j move left
    bindsym $mod+Shift+k move down
    bindsym $mod+Shift+l move up
    bindsym $mod+Shift+h move right

    # Arrow keys for focused window movement
    bindsym $mod+Shift+Left move left
    bindsym $mod+Shift+Down move down
    bindsym $mod+Shift+Up move up
    bindsym $mod+Shift+Right move right

    # Split in horizontal orientation
    bindsym $mod+h split h

    # Split in vertical orientation
    bindsym $mod+v split v

    # Enter fullscreen mode for the focused container
    bindsym $mod+f fullscreen toggle

    # Change container layout (stacked, tabbed, toggle split)
    bindsym $mod+s layout stacking
    bindsym $mod+w layout tabbed
    bindsym $mod+e layout toggle split

    # Toggle tiling / floating
    bindsym $mod+Shift+space floating toggle

    # Change focus between tiling / floating windows
    bindsym $mod+space focus mode_toggle

    # Focus the parent container
    bindsym $mod+a focus parent

    # Reload the configuration file
    bindsym $mod+Shift+c reload

    # Resize window. You can also use the mouse for that
    mode "resize" {
      # Pressing right will grow the window’s width.
      # Pressing up will shrink the window’s height.
      # Pressing down will grow the window’s height.
      bindsym a resize shrink width 10 px or 10 ppt
      bindsym s resize grow height 10 px or 10 ppt
      bindsym w resize shrink height 10 px or 10 ppt
      bindsym d resize grow width 10 px or 10 ppt

      # same bindings, but for the arrow keys
      bindsym Left resize shrink width 10 px or 10 ppt
      bindsym Down resize grow height 10 px or 10 ppt
      bindsym Up resize shrink height 10 px or 10 ppt
      bindsym Right resize grow width 10 px or 10 ppt

      # back to normal: Enter or Escape
      bindsym Return mode "default"
      bindsym Escape mode "default"
    }

    # Enable floating
    for_window [app_id="nm-connection-editor"] floating enable
    for_window [app_id="gnome-disks"] floating enable
    for_window [app_id="org.ijhack."] move scratchpad

    # Make the currently focused window a scratchpad
    bindsym $mod+Shift+minus move scratchpad

    # Show the first scratchpad window
    bindsym $mod+minus scratchpad show

    # Show the sup-mail scratchpad window, if any.
    bindsym $mod+Shift+s [app_id="org.ijhack."] scratchpad show

    #######################
    #                     #
    #     WORKSPACES      #
    #                     #
    #######################
    # Variables
    set $workspace1 "1: "
    set $workspace2 "2: "
    set $workspace3 "3: "
    set $workspace4 "4: "
    set $workspace5 "5: "
    set $workspace6 "6: "
    set $workspace7 "7"
    set $workspace8 "8"
    set $workspace9 "9"
    set $workspace10 "10"

    assign [app_id="org.kde.quassel"] $workspace3
    assign [app_id="firefox"] $workspace2
    assign [class="Daily"] $workspace5

    assign [app_id="virt-manager"] $workspace4

    assign [class="libreoffice"] $workspace6
    assign [class="Eclipse"] $workspace6

    # Inhibit idle
    for_window [app_id="firefox"] inhibit_idle fullscreen

    # Disable title bar
    for_window [app_id="kitty"] border none

    # Workspace lateral movement
    bindsym $mod+Next workspace next
    bindsym $mod+Prior workspace prev

    # Switch to workspace
    bindsym $mod+1 workspace $workspace1
    bindsym $mod+2 workspace $workspace2
    bindsym $mod+3 workspace $workspace3
    bindsym $mod+4 workspace $workspace4
    bindsym $mod+5 workspace $workspace5
    bindsym $mod+6 workspace $workspace6
    bindsym $mod+7 workspace $workspace7
    bindsym $mod+8 workspace $workspace8
    bindsym $mod+9 workspace $workspace9
    bindsym $mod+0 workspace $workspace10

    # Move workspace to other monitor
    bindsym $mod+Shift+Next move workspace to output right
    bindsym $mod+Shift+Prior move workspace to output left

    # move focused container to workspace
    bindsym $mod+Shift+1 move container to workspace $workspace1
    bindsym $mod+Shift+2 move container to workspace $workspace2
    bindsym $mod+Shift+3 move container to workspace $workspace3
    bindsym $mod+Shift+4 move container to workspace $workspace4
    bindsym $mod+Shift+5 move container to workspace $workspace5
    bindsym $mod+Shift+6 move container to workspace $workspace6
    bindsym $mod+Shift+7 move container to workspace $workspace7
    bindsym $mod+Shift+8 move container to workspace $workspace8
    bindsym $mod+Shift+9 move container to workspace $workspace9
    bindsym $mod+Shift+0 move container to workspace $workspace10


    # Dismiss mako notification
    bindsym Control+Space exec --no-startup-id ${pkgs.mako}/bin/makoctl dismiss

    #######################
    #                     #
    #  FUNCTION KEYS      #
    #                     #
    #######################
    # Backlight controls
    bindsym XF86MonBrightnessUp exec --no-startup-id xbacklight +10
    bindsym XF86MonBrightnessDown exec --no-startup-id xbacklight -10

    # Pulse Audio controls
    bindsym XF86AudioRaiseVolume exec --no-startup-id pactl set-sink-volume 0 +5% #increase sound volume
    bindsym XF86AudioLowerVolume exec --no-startup-id pactl set-sink-volume 0 -5% #decrease sound volume
    bindsym XF86AudioMute exec --no-startup-id pactl set-sink-mute 0 toggle # mute sound
    bindsym XF86AudioMicMute exec --no-startup-id  amixer set Capture toggle


    #######################
    #                     #
    #     WALLPAPERS      #
    #                     #
    #######################
    output * background ${wallpaper_path} stretch


    #######################
    #                     #
    #      AUTOLOCK       #
    #                     #
    #######################
    exec --no-startup-id swayidle -w \
        timeout 300 '${lock_screen}' \
        timeout 600 'swaymsg "output * dpms off"' \
             resume 'swaymsg "output * dpms on"' \
        before-sleep '${lock_screen}'

    #######################
    #                     #
    #        INPUT        #
    #                     #
    #######################
    input * {
      xkb_layout de
    }


    input type:mouse {
      accel_profile adaptive
      pointer_accel 0.4
    }

    input type:touchpad {
      accel_profile adaptive
      middle_emulation disabled
      tap enabled
      pointer_accel 0.4
      natural_scroll disabled
      dwt enabled
      drag enabled
      scroll_method two_finger
    }


    #######################
    #                     #
    #         BAR         #
    #                     #
    #######################
    bar {
        status_command ${i3_status_script}
        mode dock
        position top
        tray_output none

        font pango:Font Awesome 5 Free-Regular-400 14
        font pango:Andale Mono 14

        # Scrolling on bar changes volume
        bindsym button4 exec --no-startup-id pactl set-sink-volume 0 +5%
        bindsym button5 exec --no-startup-id pactl set-sink-volume 0 +-5%

        # Right mouse click mutes the volume
        bindsym button3 exec --no-startup-id pactl set-sink-mute 0 toggle


        colors {
          background #0d0d0d
          statusline #ffe066

          inactive_workspace #0d0d0d #0d0d0d #ffe066
          active_workspace #0d0d0d #0d0d0d #3f3f3f
          urgent_workspace #0d0d0d #0d0d0d #ff8533
        }
    }

    #######################
    #                     #
    #       AUTORUNS      #
    #                     #
    #######################
    # automatic display control
    exec systemd-cat -t kanshi kanshi

    # Start firefox
    exec systemd-cat -t firefox firefox -P default-default

    # Quassel client
    exec systemd-cat -t quassel quasselclient

    # Start Qt-Pass
    exec systemd-cat -t qtpass qtpass

    # Start mail client
    exec systemd-cat -t thunderbird thunderbird '';

in {

  # Allow users in video group to change brightness
  hardware.brightnessctl.enable = true;

  services.xserver.enable = true;
  services.xserver.layout = "de";
  programs.sway.enable = true;

  # Set sway to unstable package
 # nixpkgs.config.packageOverrides = super: {
 #   sway = pkgs.sway;
 # };

  environment.systemPackages = with pkgs; [
    rofi     # Dmenu replacement
    acpilight # Replacement for xbacklight
    acpi

    # Add qtgraphicaleffects as dependencie
    (pkgs.sddm.overrideAttrs (oldAttrs: {
      buildInputs = oldAttrs.buildInputs ++ [ pkgs.qt512.qtgraphicaleffects  ];
    }))
  ];

  systemd.user.targets.sway-session = {
    enable = true;
    description = "sway compositor session";
    documentation = ["man:systemd-special(7)"];
    bindsTo = ["graphical-session.target"];
    wants = ["graphical-session-pre.target"];
    after = ["graphical-session-pre.target"];
  };

  services.xserver.displayManager = {
    extraSessionFilePackages = [ pkgs.sway  ];
    session = lib.mkForce [{
      manage = "window";
      name = "sway";
      start = ''
      '';
      }];

    sddm = {
        enable = true;
        enableHidpi = true;
        theme = "${theme_path}";
    };
  };

  system.activationScripts.copySwayConfig = ''

    mkdir -p ${config.mainUserHome}/.config/sway
    ln -f -s ${i3_conf_file} ${config.mainUserHome}/.config/sway/config
    chown -R ${config.mainUser}: ${config.mainUserHome}/.config/sway

    # .Xresources for mouse
    ln -f -s ${xresources} ${config.mainUserHome}/.Xresources
    chown -h ${config.mainUser}: ${config.mainUserHome}/.Xresources
  '';
}
