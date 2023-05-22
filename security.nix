{ pkgs, config, lib, ... }:
{
  # Set sudo timeout to 30 mins
  security.sudo = {
    enable = true;
    extraConfig = "Defaults        env_reset,timestamp_timeout=30";
    wheelNeedsPassword = false;
  };

  nix.settings.trusted-users = [ "${config.mainUser}" ];

  # Every user can see perf events
  # Needed for whole system profiling
  boot.kernel.sysctl = {
    "kernel.perf_event_paranoid" = 0;
    "kernel.kptr_restrict" = 0;
  };

  # Firmware updater
  services.fwupd.enable = true;

  # Auto upgrade
  system.autoUpgrade = {
    enable = true;
    dates = "0/3:00:00"; # Check every 3 hours for updates
    flake = "/etc/nixos";
    allowReboot = true;
    flags = ["--impure" "--recreate-lock-file" "--commit-lock-file"];
  };

 # nixPath = [
 #   "nixpkgs=${pkgs.unstable.pkgs}"
 #   "nixos=${pkgs}"
 #   "/nix/var/nix/profiles/per-user/root/channels"
 # ];
}
