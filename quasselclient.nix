{ config, pkgs, lib, ... }:
{

programs.firejail.wrappedBinaries = {
  quasselClient = "--profile=quassel ${pkgs.quasselClient}/bin/quasselclient";
};


system.activationScripts.quasselCopy = ''

CONFIG_FILE_PATH="${config.mainUserHome}/.config/quassel-irc.org"
mkdir -p $CONFIG_FILE_PATH

CONFIG_FILE="${config.mainUserHome}/.config/quassel-irc.org/quasselclient.conf"

cp "${config.secrets}/quasselclient.conf" "$CONFIG_FILE"
chown -R ${config.mainUser}: $CONFIG_FILE_PATH
'';

}
