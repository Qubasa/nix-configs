{pkgs, config, lib, ... }:
let
    theme = pkgs.writeText "theme_config" ''
      [Settings]
      gtk-theme-name=Adwaita
      gtk-icon-theme-name=hicolor
      gtk-font-name=Sans 10
      gtk-cursor-theme-name=capitaine-cursors
      gtk-cursor-theme-size=0
      gtk-toolbar-style=GTK_TOOLBAR_BOTH
      gtk-toolbar-icon-size=GTK_ICON_SIZE_LARGE_TOOLBAR
      gtk-button-images=1
      gtk-menu-images=1
      gtk-enable-event-sounds=1
      gtk-enable-input-feedback-sounds=1
      gtk-xft-antialias=1
      gtk-xft-hinting=1
      gtk-xft-hintstyle=hintslight
      gtk-xft-rgba=rgb
      gtk-application-prefer-dark-theme=1
    '';
  in {
    environment.systemPackages = with pkgs; [
      adapta-gtk-theme
      lxappearance
      capitaine-cursors
      gnome3.adwaita-icon-theme
      gnome2.gnome_icon_theme
      hicolor_icon_theme
    ];

    system.activationScripts.copyThemeConfig = ''
      CONFIG_FOLDER=${config.mainUserHome}/.config/gtk-3.0
      CONFIG_FILE_PATH=$CONFIG_FOLDER/settings.ini
      mkdir -p $CONFIG_FOLDER
      ln -f -s ${theme} $CONFIG_FILE_PATH
      chown -h ${config.mainUser}: $CONFIG_FILE_PATH
    '';


  }
