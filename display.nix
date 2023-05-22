{ config, pkgs, lib, ... }:

{
  services.xserver.enable = true;
  services.xserver.layout = "de";

  services.xserver.displayManager.gdm = {
    enable = true;
    wayland = false;
  };

  programs.gnome-terminal.enable = false;

  services.xserver.desktopManager.gnome = {
    enable = true;
  };

  qt5 = {
    enable = true;
    platformTheme = "gnome";
    style = "adwaita-dark";
  };

  # Fix screen tearing
  services.xserver.deviceSection = ''
      Option "TearFree" "true"
  '';

  # Enable Systembus notifications
  services.systembus-notify.enable = true;

  programs.ssh.enableAskPassword = true;
  environment.gnome.excludePackages = with pkgs; [ gnome-console ];

  # Needed for tray icon support. Enable in 'extension' gnome app
  environment.systemPackages = with pkgs.gnomeExtensions; [
        shu-zhi
        #forge
        appindicator
        night-theme-switcher
        tactile

  ] ++ (with pkgs; [ gnome.pomodoro fortune ]) ++ (with pkgs.master.pkgs.gnomeExtensions; [
      #timepp
  ]);
  services.udev.packages = with pkgs; [ gnome3.gnome-settings-daemon ];
}
