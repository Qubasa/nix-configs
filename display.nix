{ config, pkgs, lib, ... }:

{
  services.xserver.enable = true;
  services.xserver.xkb.layout = "de";

  services.xserver.displayManager.gdm = {
    enable = true;
    wayland = true;
  };

  # Don't disable as extensions rely on it sometimes
  # programs.gnome-terminal.enable = true;

  services.xserver.desktopManager.gnome = {
    enable = true;
  };

  qt = {
    enable = true;
    platformTheme = "gnome";
    style = "adwaita";
  };

 # environment.variables = {
 #   # This will become a global environment variable
 #   "QT_STYLE_OVERRIDE" = lib.mkForce "kvantum";
 # };

  # Fix screen tearing
  #  services.xserver.deviceSection = ''
  #      Option "TearFree" "true"
  #  '';

  # Enable Systembus notifications
  services.systembus-notify.enable = true;

  programs.ssh.enableAskPassword = true;
  #environment.gnome.excludePackages = with pkgs; [ gnome-console ];

  # Needed for tray icon support. Enable in 'extension' gnome app
  environment.systemPackages = with pkgs.gnomeExtensions; [
    appindicator
    tactile

  ] ++ (with pkgs; [
    gnome.pomodoro
    night-theme-switcher
    ibus
  ]);
  services.udev.packages = with pkgs; [ gnome3.gnome-settings-daemon ];
}
