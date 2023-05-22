{ config, pkgs, ... }:


let



in {
  environment.systemPackages = [  ];

  # Enable nix ld
  programs.nix-ld.enable = true;

  environment.variables = with pkgs;  {
     #NIX_LD = lib.fileContents "${pkgs.stdenv.cc}/nix-support/dynamic-linker";
     # Can create bugs if the calling process uses a different glibc then this fuse does
     # However this is needed to run AppImages as they do not have a reference to a link loader in their binary
     # Thus not triggering nix-ld
     # LD_LIBRARY_PATH =  lib.mkForce ( (lib.makeLibraryPath [ fuse3 fuse ]) + ":" + config.environment.sessionVariables.LD_LIBRARY_PATH);
     NIX_LD_LIBRARY_PATH = lib.makeLibraryPath [
      stdenv.cc.cc
      zlib
      fuse3
      alsa-lib
      at-spi2-atk
      at-spi2-core
      atk
      cairo
      cups
      curl
      dbus
      expat
      fontconfig
      freetype
      gdk-pixbuf
      glib
      gtk3
      libGL
      libappindicator-gtk3
      libdrm
      libnotify
      gnome2.gtk
      xorg.libSM
      libgudev
      libpulseaudio
      libuuid
      xorg.libxcb
      libxkbcommon
      mesa
      nspr
      nss
      pango
      pipewire
      systemd
      xorg.libX11
      xorg.libXScrnSaver
      xorg.libXcomposite
      xorg.libXcursor
      xorg.libXdamage
      xorg.libXext
      xorg.libXfixes
      xorg.libXi
      xorg.libXrandr
      xorg.libXrender
      xorg.libXtst
      xorg.libxkbfile
      xorg.libxshmfence
      zlib
     ];
  };

}
