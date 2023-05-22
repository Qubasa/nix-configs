{pkgs, config, lib, ...}:

{
  systemd.user.services."decrypt-server" =  rec {
    enable = true;
    serviceConfig.Type = "simple";

    path = with pkgs; [
        coreutils
        config.programs.ssh.package
      ];
    script = let
      password = builtins.readFile "${config.secrets}/kvm-server/decrypt.pwd";
    in ''
      DECRYPT='echo "" > ~/.ash_history && echo "${password}" | zfs load-key -a && killall zfs'
      ssh kvm-server-decrypt $DECRYPT
    '';
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    startAt = "Thu *-*-* 19:10:00";
    serviceConfig = {
      RestartSec = "60s";
      Restart = "on-failure";
    };
  };

  systemd.timers."decrypt-server" = {
    timerConfig = {
      Persistent = true;
      WakeSystem = true;
    };
  };
}