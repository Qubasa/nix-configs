{ config, pkgs, ... }:
let
  dest = "restic.gchq.icu";
  user = "thinkpad-backup";
  repo-path = "thinkpad-repo";
  port = "4000";

  # NOTE:
  # You have to connect to the machine at least once manually as root to
  # accept the rsa key!

in {
  services.restic.backups.thinkpad =
  {
    initialize = true;
    paths = [ "/home/${config.mainUser}" "${config.secrets}" "/etc/nixos" "/etc/NetworkManager/system-connections" ];
    user = "root";
    extraOptions = [ "sftp.command='ssh -p ${port} ${user}@${dest} -i ${config.secrets}/restic/restic_keys -s sftp'" ];
    repository = "sftp:${user}@${dest}:/home/${user}/${repo-path}";
    passwordFile = "${config.secrets}/restic/thinkpad.pwd";
    extraBackupArgs = [ "--exclude '${config.mainUser}/VirtualBox VMs'" "--exclude '${config.mainUser}/Iso'" ];
    timerConfig = { OnCalendar = "0/5:00:00"; }; # Backup every 5 hours
  };


}
